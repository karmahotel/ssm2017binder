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
// =============== //
//   strings       //
// =============== //
string _BLOG_POSTER_READY = "Blog poster ready";
// menu
string _CHOOSE_AN_OPTION = "Choose an option";
string _RESET = "Reset";
// wait for the notecard
string _DELETING_ITEM = "Deleting item";
string _NO_NOTECARD_WAS_FOUND = "No notecard was found";
// notecard reading
string _START_READING_THE_NOTECARD = "Start reading the notecard";
string _NOTECARD_READ = "Notecard read";
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
string status = "1";
integer use_nl = TRUE;
// *********************************************** //
//    NOTHING SHOULD BE CHANGED UNDER THIS LINE     //
// *********************************************** //
string body;
integer menu_listener;
integer menu_channel;
key owner;
// format the body
string get_body() {
    return "<?xml version=\"1.0\"?><methodCall><methodName>blogger.newPost</methodName><params>"
    + "<param><value><string/></value></param><param><value><string/></value></param>"
    + "<param><value><string>"+ username+ "</string></value></param>"
    + "<param><value><string>"+ password+ "</string></value></param>"
    + "<param><value><string>&#60;title&#62;"+ title+ "&#60;/title&#62;&#60;category&#62;"+ categories+ "&#60;/category&#62;<![CDATA["+ body+ "]]></string></value></param>"
    + "<param><value><int>"+ status+ "</int></value></param>"
    + "</params></methodCall>";
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
  list values = llParseString2List(body, ["/>","<", ">"], []);
  string output = "";
  if (llList2String(values, 10) == "int") {
      string id = llList2String(values, 11);
      llOwnerSay(_POST_SUCCEDED+ " "+ _POST_ID+ " = "+ id);
      llOwnerSay(url+ "/?p="+ id);
      llLoadURL(owner, title, url+"/?p="+ id);
  }
  else {
    llOwnerSay(_POST_FAILED+ " : "+ _SERVER_ANSWERED+ body);
  }
}
// ********************** //
//    WAIT FOR NOTECARD   //
// ********************** //
string notecard_name;
integer i_line;
key notecard_id;
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
        notecard_id = llGetNotecardLine(notecard_name,i_line);
        body = "";
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
                // get the tile
                if (i_line == 0) {
                    title = data;
                }
                // get the categories ids
                if (i_line == 1) {
                    categories = data;
                }
                // get the post status
                if (i_line == 2) {
                    status = data;
                }
                if (i_line >2) {
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
                llOwnerSay(_NOTECARD_READ);
                // deleting the notecard
                llRemoveInventory(notecard_name);
                state post;
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
            + _CATEGORIES+ " = "+ categories+ "\n"
            + _PUBLISH_STATUS+ " = "+ status+ "\n"
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
                reqid = llHTTPRequest( url+"/xmlrpc.php", [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], get_body() );
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
        else if (status != 403) {
            llOwnerSay(_FORBIDEN_ACCES);
        }
        else if (status != 404) {
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