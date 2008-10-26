// @version slPresentor
// @package remote
// @copyright Copyright wene / ssm2017 Binder (C) 2008. All rights reserved.
// @license http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
// slPresentor is free software and parts of it may contain or be derived from the
// GNU General Public License or other free or open source software licenses.

// ******** USER PARAMETERS ******** //
integer channel = 999;
string defaultTexture = "5748decc-f629-461c-9a36-a35a221fe21f";
integer hudTextureSide = 4;
// ******************************************* //
//  NOTHING SHOULD BE CHANGED UNDER THIS LINE  //
// ******************************************* //
string password;
list textures = [];
integer texturesQty;
integer iLine = 0;
integer display;
integer actTexture;
setPreview()
{
    integer nextTexture = actTexture+1;
    integer prevTexture = actTexture-1;
    if ( prevTexture < 0 )
    {
        prevTexture = texturesQty-1;
    }
    if ( nextTexture > (texturesQty-1) )
    {
        nextTexture = 0;
    }
    llMessageLinked(LINK_SET, 0, llList2String(textures,prevTexture), (key)"setPrevTexture");
    llMessageLinked(LINK_SET, 0, llList2String(textures,nextTexture), (key)"setNextTexture");
}
default
{
    on_rez(integer number)
    {
        llResetScript();
    }
    state_entry()
    {
        password = llGetObjectDesc();
        llOwnerSay("Checking for textures...");
        actTexture = -1;
        texturesQty = llGetInventoryNumber(INVENTORY_TEXTURE);
        if ( texturesQty )
        {
            llOwnerSay("Found : "+(string)texturesQty);
            integer i = 0;
            while( i < (texturesQty) )
            {
                textures = (textures=[]) + textures + [llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE, i))];
                ++i;
            }
            state run;
        }
        else
        {
            llOwnerSay("/!\\ No texture found. The script will stop.");
            return;
        }
    }
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            llOwnerSay("Inventory has changed...Reseting script...");
            llResetScript();
        }
    }
}
state run
{
    on_rez(integer number)
    {
        llResetScript();
    }
    state_entry()
    {
        llSetTexture(defaultTexture,hudTextureSide);
        setPreview();
    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        string value = "";
        string command = (string)id;
        if ( command == "nextSlide" )
        {
            ++actTexture;
            if ( actTexture > (texturesQty -1) )
            {
                actTexture = 0;
            }
            value = "setTexture;"+llList2String(textures,actTexture);
            llSetTexture(llList2String(textures,actTexture),hudTextureSide);
            setPreview();
        }
        else if ( command == "prevSlide" )
        {
            --actTexture;
            if ( actTexture < 0 )
            {
                actTexture = texturesQty - 1;
            }
            value = "setTexture;"+llList2String(textures,actTexture);
            llSetTexture(llList2String(textures,actTexture),hudTextureSide);
            setPreview();
        }
        else if ( command == "defaultTexture" )
        {
            value = "setTexture;"+defaultTexture;
            llSetTexture(defaultTexture,hudTextureSide);
        }
        else if ( command == "toggle" )
        {
            value = str;
        }
        else if ( command == "setGlow" )
        {
            value = str;
        }
        else if ( command == "reset" )
        {
            llResetScript();
        }
        llRegionSay(channel, password+";"+value);
    }
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)
        {
            llOwnerSay("Inventory has changed...Reseting script...");
            llResetScript();
        }
    }
}