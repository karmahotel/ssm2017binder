// @version slPresentor
// @package remote
// @copyright Copyright wene / ssm2017 Binder (C) 2007-2008. All rights reserved.
// @license http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
// slPresentor is free software and parts of it may contain or be derived from the
// GNU General Public License or other free or open source software licenses.
integer hudTextureSide = 4;
default
{
    link_message(integer sender_num, integer num, string str, key id)
    {
        string value = "";
        string command = (string)id;
        if ( command == "setPrevTexture" )
        {
            llSetTexture(str, hudTextureSide);
        }
    }
}