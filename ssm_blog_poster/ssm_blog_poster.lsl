// ssm2017 Binder : ssm_blog_poster
// @copyright  Copyright (C) 2009 ssm2017 Binder (S.Massiaux). All rights reserved. 
// @license  GNU/GPL, http://www.gnu.org/licenses/gpl-2.0.html 
// ssm_blog_poster is free software. This version may have been modified pursuant to the 
// GNU General Public License, and as distributed it includes or is derivative 
// of works licensed under the GNU General Public License 
// or other free or open source software licenses.

// login values
string username = "";
string password = "";
string url = "";
string cms = "wordpress"; // use joomla or drupal or wordpress
// =============== //
//   strings       //
// =============== //
string _BLOG_POSTER_READY = "Blog poster ready";
string _SCRIPT_WILL_STOP = "Script will stop";
// menu
string _CHOOSE_AN_OPTION = "Choose an option";
string _RESET = "Reset";
// wait for the notecard
string _DELETING_ITEM = "Deleting item";
string _NO_NOTECARD_WAS_FOUND = "No notecard was found";
// notecard reading
string _START_READING_THE_NOTECARD = "Start reading the notecard";
string _NOTECARD_READ = "Notecard read";
string _NO_BODY_DEFINED = "No body defined";
string _THE_TAG = "The tag";
string _IS_MISSING = "is missing";
// post
string _DO_YOU_REALLY_WANT_TO_POST_THIS_MESSAGE = "Do you really want to post this message ?";
string _TITLE = "Title";
string _CATEGORIES = "Categories";
string _PUBLISH_STATUS = "Publish status";
string _BODY = "Body";
string _POST = "Post";
string _POST_SUCCEEDED = "Post succeeded";
string _POST_ID = "Post id";
string _POST_FAILED = "Post failed";
string _SERVER_ANSWERED = "Server answered";
// http errors
string _REQUEST_TIMED_OUT = "Request timed out";
string _FORBIDDEN_ACCESS = "Forbidden access";
string _PAGE_NOT_FOUND = "Page not found";
string _INTERNET_EXPLODED = "the internet exploded!!";
string _SERVER_ERROR = "Server error";
// =============== //
//   default params       //
// =============== //
string title;
string categories = "0";
string publish_status = "1";
integer use_nl = TRUE;
string body_separator = "<!--body-->";
string content_type = "blog";
// *********************************************** //
//    NOTHING SHOULD BE CHANGED UNDER THIS LINE     //
// *********************************************** //
// read config data
read_config(string data) {
    list parsed = llParseString2List( data, [ "=" ], [] );
    string param = llToLower(llStringTrim(llList2String( parsed, 0 ), STRING_TRIM));
    string value = llStringTrim(llList2String( parsed, 1 ), STRING_TRIM);
    if (param != "") {
        if (param == "url") {
            url = value;
        }
        else if (param == "username") {
            username = value;
        }
        else if (param == "password") {
            password = value;
        }
        else if (param == "cms") {
            cms = value;
        }
        else if (param == "content_type") {
            content_type = value;
        }
        else if (param == "publish_status") {
            publish_status = value;
        }
        else if (param == "categories") {
            categories = value;
        }
        else if (param == "title") {
            title = value;
        }
        else if (param == "body_separator") {
            body_separator = value;
        }
        else if (param == "use_nl") {
            use_nl = (integer)value;
        }
    }
}
string body;
integer menu_listener;
integer menu_channel;
key owner;
// build the header
string header = "<?xml version=\"1.0\"?><methodCall><methodName>blogger.newPost</methodName><params>";
string build_credentials() {
    return "<param><value><string>"+ username+ "</string></value></param>"
            +"<param><value><string>"+ password+ "</string></value></param>";
}
string build_footer() {
    return "<param><value><boolean>"+ publish_status+ "</boolean></value></param>"
            + "</params></methodCall>";
}
// format the body
string get_body() {
    string output = header;
    // get values for wordpress
    if (cms == "wordpress") {
        output += "<param><value><string/></value></param><param><value><string/></value></param>";
        output += build_credentials();
        output += "<param><value><string>&#60;title&#62;"+ title+ "&#60;/title&#62;&#60;category&#62;"+ categories+ "&#60;/category&#62;<![CDATA["+ body+ "]]></string></value></param>";
    }
    // get values for drupal
    else if (cms == "drupal") {
        output += "<param><value><string/></value></param><param><value><string>"+ content_type+ "</string></value></param>";
        output += build_credentials();
        output += "<param><value><string>&#60;title&#62;"+ title+ "&#60;/title&#62;<![CDATA["+ body+ "]]></string></value></param>";
    }
    // get values for joomla
    else if (cms == "joomla") {
        output += "<param><value><string/></value></param><param><value><string>"+ llGetSubString(categories, 0, 1)+ "</string></value></param>";
        output += build_credentials();
        output += "<param><value><string>&#60;title&#62;"+ title+ "&#60;/title&#62;<![CDATA["+ body+ "]]></string></value></param>";
    }
    // close the message
    output += build_footer();
    return output;
}
drupal_add_taxonomy(string post_id) {
   string output = "<?xml version=\"1.0\"?><methodCall><methodName>mt.setPostCategories</methodName><params>";
   // output += "<param><value><boolean/></value></param>";
   output += "<param><value><string>"+ post_id+ "</string></value></param>";
   output += build_credentials();
   // build categories
   string cats = "<param><value><array><data>";
   list cats_list = llCSV2List(categories);
   integer cats_count = llGetListLength(cats_list);
   integer i;
   for (i=0; i<cats_count; ++i) {
     // cats += "<value><categoryId><string>"+ llList2String(cats_list, i)+ "</string></categoryId></value>";
       cats += make_drupal_category_value(llList2String(cats_list, i));
   }
   cats += "</data></array></value></param>";
   if (cats_count > 0) {
     output += cats;
   }
   output += "</params></methodCall>";
   reqid = llHTTPRequest( url+"/xmlrpc.php", [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], output );
   categories = "0";
}
string make_drupal_category_value(string cat) {
   return tag("value",
              tag("struct",
                  tag("member",
                      tag("name", "categoryId") +
                      tag("value", tag("string", cat)))));
}
string tag(string tag_name, string content) {
   return "<" + tag_name + ">" + content + "</" + tag_name + ">";
}
key reqid;
// delete inventory content
delete_content(integer delete_notecard) {
    integer inventory_qty = llGetInventoryNumber(INVENTORY_ALL);
    notecard_name = llGetInventoryName(INVENTORY_NOTECARD, 0);
    integer i;
    for (i=0; i<inventory_qty; ++i) {
        string name = llGetInventoryName(INVENTORY_ALL, i);
        if (name != llGetScriptName()) {
            if (delete_notecard) {
                llRemoveInventory(name);
                llOwnerSay(_DELETING_ITEM+ " : "+ name);
            }
            else {
                if (name != notecard_name) {
                  llRemoveInventory(name);
                  llOwnerSay(_DELETING_ITEM+ " : "+ name);
                }
            }
        }
    }
}
string drupal_post_id = "";
// get the answer
get_site_answer(string body) {
    list data = llParseString2List(body, ["/>","<", ">"], []);
    string output = "";
    integer success = FALSE;
    if (cms == "wordpress") {
        display_answer(check_answer(data, 27, 32, 11), "/?p=");
    }
    else if (cms == "drupal") {
        string drupal_answer = check_answer(data, 27, 32, 10);
        if (categories != "0") {
            if (posted_success) {
                drupal_post_id = drupal_answer;
                drupal_add_taxonomy(drupal_answer);
            }
            else {
                display_answer(drupal_answer, "/?q=node/");
            }
        }
        else {
            if (drupal_post_id != "" && posted_success) {
                drupal_answer = drupal_post_id;
                drupal_post_id = "";
            }
            display_answer(drupal_answer, "/?q=node/");
        }
    }
    else if (cms == "joomla") {
        display_answer(check_answer(data, 25, 30, 10), "/index.php?option=com_content&view=article&id=");
    }
}
// check if the message was posted
integer posted_success = FALSE;
string check_answer(list data, integer error_idx, integer msg_idx, integer id_idx) {
    if (llList2String(data, error_idx) == "faultString") {
        posted_success = FALSE;
        return llList2String(data, msg_idx);
    }
    else {
        string id = llList2String(data, id_idx);
        posted_success = TRUE;
        return id;
    }
}
// display answer from server
display_answer(string answer, string url_str) {
    if (posted_success) {
        llOwnerSay(_POST_SUCCEEDED+ " "+ _POST_ID+ " = "+ answer);
        llOwnerSay(url+ url_str+ answer);
        llLoadURL(owner, title, url+ url_str+ answer);
    }
    else {
        llOwnerSay(_POST_FAILED+ " \n"+ _SERVER_ANSWERED+ " : "+ answer);
    }
    posted_success = FALSE;
}
// get server answer
getServerAnswer(integer status, string body) {
    if (status == 499) {
        llOwnerSay((string)status+ " "+ _REQUEST_TIMED_OUT);
    }
    else if (status == 403) {
        llOwnerSay((string)status+ " "+ _FORBIDDEN_ACCESS);
    }
    else if (status == 404) {
        llOwnerSay((string)status+ " "+ _PAGE_NOT_FOUND);
    }
    else if (status == 500) {
        llOwnerSay((string)status+ " "+ _SERVER_ERROR);
    }
    else if (status != 403 && status != 404 && status != 500) {
        llOwnerSay((string)status+ " "+ _INTERNET_EXPLODED);
        llOwnerSay(body);
    }
}
// ********************** //
//    WAIT FOR NOTECARD   //
// ********************** //
string notecard_name;
integer i_line;
key notecard_id;
integer config_values = TRUE;
default
{
    state_entry()
    {
        menu_channel = llFloor(llFrand(100000.0)) + 1000;
        owner = llGetOwner();
        delete_content(TRUE);
        llOwnerSay(_BLOG_POSTER_READY);
    }
    touch_start(integer total_number)
    {
        if ( llDetectedKey(0) == owner )
        {
            menu_listener = llListen(menu_channel,"", owner,"");
            llDialog(owner, _CHOOSE_AN_OPTION+ " : ", [_RESET], menu_channel);
        }
    }
    listen(integer channel, string name, key id, string message)
    {
        if (channel == menu_channel)
        {
            if (message == _RESET)
            {
                llResetScript();
            }
            llListenRemove(menu_listener);
        }
    }
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            // delete everything in the inventory except the script and the notecard
            delete_content(FALSE);
            if (notecard_name != "") {
                state read_notecard;
            }
            else {
                llOwnerSay(_NO_NOTECARD_WAS_FOUND);
            }
        }
    }
}
// ********************** //
//    READ THE NOTECARD   //
// ********************** //
state read_notecard
{
    state_entry()
    {
        // read the config notecard
        i_line=0;
        config_values = TRUE;
        body = "";
        notecard_id = llGetNotecardLine(notecard_name,i_line);
        llOwnerSay(_START_READING_THE_NOTECARD);
    }
    touch_start(integer total_number)
    {
        if ( llDetectedKey(0) == owner )
        {
            menu_listener = llListen(menu_channel,"", owner,"");
            llDialog(owner, _CHOOSE_AN_OPTION+ " : ", [_RESET], menu_channel);
        }
    }
    listen(integer channel, string name, key id, string message)
    {
        if (channel == menu_channel)
        {
            if (message == _RESET)
            {
                llResetScript();
            }
            llListenRemove(menu_listener);
        }
    }
    dataserver(key queryId, string data)
    {
        if ( queryId == notecard_id )
        {
            if(data != EOF)
            {
                // remove trailing spaces
                data = llStringTrim(data, STRING_TRIM);
                // check config values
                if (config_values == TRUE) {
                    if (data != body_separator) {
                        read_config(data);
                    }
                    else {
                        config_values = FALSE;
                    }
                }
                else {
                    if (use_nl) {
                        body += data+ "\n";
                    }
                    else {
                        body += data;
                    }
                }
                notecard_id = llGetNotecardLine(notecard_name,++i_line);
            }
            else
            {
                if (config_values == TRUE) {
                    llOwnerSay(_NO_BODY_DEFINED);
                    llOwnerSay(_THE_TAG+ " "+ body_separator+ " "+ _IS_MISSING);
                    llOwnerSay(_SCRIPT_WILL_STOP);
                    state default;
                }
                else {
                    llOwnerSay(_NOTECARD_READ);
                    // deleting the notecard
                    llRemoveInventory(notecard_name);
                    state post;
                }
            }
        }
    }
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            // delete everything in the inventory except the script and the notecard
            delete_content(FALSE);
            if (notecard_name != "") {
                state read_notecard;
            }
            else {
                llOwnerSay(_NO_NOTECARD_WAS_FOUND);
            }
        }
    }
}
// ********************** //
//      MAIN PROGRAM      //
// ********************** //
state post {
    state_entry() {
        // format the menu content
        string preview_body = body;
        if (llStringLength(body) > 256) {
            preview_body = llDeleteSubString(body, 256, -1);
        }
        string menu_content = _DO_YOU_REALLY_WANT_TO_POST_THIS_MESSAGE+ "\n"
            + _TITLE+ " = "+ title+ "\n"
            + _PUBLISH_STATUS+ " = "+ publish_status+ "\n"
            + _BODY+ " = "+ preview_body;
        menu_listener = llListen(menu_channel,"", owner,"");
        llDialog(owner, menu_content, [_RESET, _POST], menu_channel);
    }
    touch_start(integer total_number)
    {
        if ( llDetectedKey(0) == owner )
        {
            menu_listener = llListen(menu_channel,"", owner,"");
            llDialog(owner, _CHOOSE_AN_OPTION+ " : ", [_RESET], menu_channel);
        }
    }
    listen(integer channel, string name, key id, string message)
    {
        if (channel == menu_channel)
        {
            if (message == _RESET)
            {
                llResetScript();
            }
            else if (message == _POST) {
                string url2 = url+"/xmlrpc.php";
                if (cms == "joomla") {
                    url2 = url+ "/xmlrpc/index.php";
                }
                reqid = llHTTPRequest( url2, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], get_body() );
            }
            llListenRemove(menu_listener);
        }
    }
    http_response(key id, integer status, list meta, string body) {
        if (id != reqid) {
            return;
        }
        if (status != 200) {
            getServerAnswer(status, body);
        }
        else {
            get_site_answer(body);
        }
    }
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            // delete everything in the inventory except the script and the notecard
            delete_content(FALSE);
            if (notecard_name != "") {
                state read_notecard;
            }
            else {
                llOwnerSay(_NO_NOTECARD_WAS_FOUND);
            }
        }
    }
}
