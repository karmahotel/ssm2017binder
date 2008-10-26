// @version slPresentor
// @package remote
// @copyright Copyright wene / ssm2017 Binder (C) 2007-2008. All rights reserved.
// @license http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
// slPresentor is free software and parts of it may contain or be derived from the
// GNU General Public License or other free or open source software licenses.
integer toggle = 0;
default
{
    touch_start(integer total_number)
    {
        string value = "";
        if ( toggle )
        {
            value = "glowOn";
            ++toggle;
        }
        else
        {
            value = "glowOff";
            --toggle;
        }
        llMessageLinked(LINK_SET, 0, value, (key)"setGlow");
    }
}