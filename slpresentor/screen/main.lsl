// @version slPresentor
// @package screen
// @copyright Copyright wene / ssm2017 Binder (C) 2007-2008. All rights reserved.
// @license http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
// slPresentor is free software and parts of it may contain or be derived from the
// GNU General Public License or other free or open source software licenses.

integer channel = 999;
string presentorName = "slPresentor-Remote";
integer side = 4;
integer password = 1234;
key owner;
default
{
    on_rez(integer number)
    {
        llResetScript();
    }
    state_entry()
    {
        owner = llGetOwner();
        llListen(channel, presentorName, "", "");
        llListen(channel,"", owner, "");
    }
    listen(integer channel, string name, key id, string message)
    {
        list values = llParseStringKeepNulls(message,[";"],[]);
        string command;
        if ( id == owner )
        {
            command = llList2String(values,0);
            if ( command == "pass" )
            {
                password = llList2Integer(values,1);
            }
        }
        else
        {
            if ( llList2Integer(values,0) == password )
            {
                command = llList2String(values,1);
                if (command == "show")
                {
                    llSetPrimitiveParams([
                        PRIM_GLOW, side, 0.1,
                        PRIM_COLOR, side, <1,1,1>, 1
                    ]);
                }
                else if (command == "hide")
                {
                    llSetPrimitiveParams([
                        PRIM_GLOW, side, 0.0,
                        PRIM_COLOR, side, <0,0,0>, 1
                    ]);
                }
                else if ( command == "glowOn" )
                {
                    llSetPrimitiveParams([
                        PRIM_GLOW, side, 0.1
                    ]);
                }
                else if ( command == "glowOff" )
                {
                    llSetPrimitiveParams([
                        PRIM_GLOW, side, 0.0
                    ]);
                }
                else if ( command == "setTexture" )
                {
                    llSetTexture(llList2String(values,2), side);
                }
            }
        }
    }
}