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
string _REQUEST_TIMED_OUT = "Request timed out";
string _FORBIDEN_ACCESS = "Forbiden access";
string _PAGE_NOT_FOUND = "Page not found";
string _INTERNET_EXPLODED = "the internet exploded!!";
string _POST_SUCCEDED = "Post succeded";
string _POST_ID = "Post id";
string _POST_FAILED = "Post failed";
string _SERVER_ANSWERED = "Server answered";
// =============== //
//   default params       //
// =============== //
string title;
string categories = "1";
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
// format the body
string get_body() {
    // common values
    string credentials = "<param><value><string>"+ username+ "</string></value></param>"
                                  + "<param><value><string>"+ password+ "</string></value></param>";
    string output = "<?xml version=\"1.0\"?><methodCall><methodName>blogger.newPost</methodName><params>";
    // get values for wordpress
    if (cms == "wordpress") {
        output += "<param><value><string/></value></param><param><value><string/></value></param>";
        output += credentials;
        output += "<param><value><string>&#60;title&#62;"+ title+ "&#60;/title&#62;&#60;category&#62;"+ categories+ "&#60;/category&#62;<![CDATA["+ body+ "]]></string></value></param>";
    }
    // get values for drupal
    else if (cms == "drupal") {
        output += "<param><value><string/></value></param><param><value><string>"+ content_type+ "</string></value></param>";
        output += credentials;
        output += "<param><value><string>&#60;title&#62;"+ title+ "&#60;/title&#62;<![CDATA["+ body+ "]]></string></value></param>";
    }
    // get values for joomla
    else if (cms == "joomla") {
        output += "<param><value><string/></value></param><param><value><string>"+ llGetSubString(categories, 0, 1)+ "</string></value></param>";
        output += credentials;
        output += "<param><value><string>&#60;title&#62;"+ title+ "&#60;/title&#62;<![CDATA["+ body+ "]]></string></value></param>";
    }
    // close the message
    output += "<param><value><boolean>"+ publish_status+ "</boolean></value></param>"
                + "</params></methodCall>";
    return output;
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
// get the answer
get_site_answer(string body) {
    list data = llParseString2List(body, ["/>","<", ">"], []);
    string output = "";
    integer success = FALSE;
    llOwnerSay(llList2CSV(data));
    if (cms == "wordpress") {
        display_answer(data, 27, 32, 11, "/?p=");
    }
    else if (cms == "drupal") {
        display_answer(data, 27, 32, 10, "/?q=");
    }
    else if (cms == "joomla") {
        display_answer(data, 25, 30, 10, "/index.php?option=com_content&view=article&id=");
    }
}
// display answer from server
display_answer(list data, integer error_idx, integer msg_idx, integer id_idx, string url_str) {
    if (llList2String(data, error_idx) == "faultString") {
        llOwnerSay(_POST_FAILED+ " \n"+ _SERVER_ANSWERED+ " : "+ llList2String(data, msg_idx));
    }
    else {
        string id = llList2String(data, id_idx);
        llOwnerSay(_POST_SUCCEDED+ " "+ _POST_ID+ " = "+ id);
        llOwnerSay(url+ url_str+ id);
        llLoadURL(owner, title, url+ url_str+ id);
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
        if (status == 499) {
            llOwnerSay(_REQUEST_TIMED_OUT);
        }
        else if (status == 403) {
            llOwnerSay(_FORBIDEN_ACCESS);
        }
        else if (status == 404) {
            llOwnerSay(_PAGE_NOT_FOUND);
        }
        else if (status != 200 && status != 403 && status != 404) {
            llOwnerSay(_INTERNET_EXPLODED);
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