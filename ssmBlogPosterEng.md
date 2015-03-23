Here is a script to be able to post blog entries from sl.

This script is working for :
  * wordpress
  * drupal
  * joomla

This script is open source, but i have made an extended version to use with wordpress that you can buy [here](http://www.xstreetsl.com/modules.php?name=Marketplace&file=item&ItemID=1261507)

To make it work, you need to add this script in a box, and create a notecard.

Then you need to fill the 3 first variables in the script :

  * username ( the username on the site )
  * password ( the password of this username on the site )
  * url ( the address of your website. ex : http://monsite.com/wordpress

During the creation of the notecard, you can change these values ( but when changing values by notecard, the values set stay in place, so you need to reset the script to go back to the default values )
Click on the object to make the rest menu appear.

Carrier returns are working and html content too.

when the notecard is created, you just need to drop it on the object and then a menu will appear after the notecard analyzis to ask you confirmation.
This script can be extended to add other options but the base is here.

**WARNING : THE NOTECARD LINES CAN NOT BE LOGER THAN 256 CHARS BECAUSE OF SL LIMIT**

# xml rpc activation on the websites #
Go to the admin panel of your site and activate xml-rpc

### activation for wordpress ###
Go to the page : wp-admin/options-writing.php and activate it.
### activation for drupal ###
  * Install the module called : blogapi
  * go to admin/settings/blogapi and choose the content type to use
  * go to admin/user/permissions and enable "administer content with blog api" for the desired user role
### activation for joomla ###
  * Go to the config page : administrator/index.php?option=com\_config and activate "web services"
  * Go to the plugins list : administrator/index.php?option=com\_plugins&client=site and publish the plugin named : XML-RPC - Blogger API

# script configuration #
You can define variables by default in the script or you can add them in the notecard that you will use for the article.

Actuallay, the variables are :
### username ###
  * definition : the username of the website
  * default value : empty
  * example : "toto"
### password ###
  * definition : password of the website
  * default value : empty
  * example : "titi"
### url ###
  * definition : url of the website
  * default value : empty
  * example : "http://mywebsite.com/wordpress"
### cms ###
  * definition : script type to use
  * default value : "wordpress"
  * possible values :
    * wordpress
    * drupal
    * joomla
### content\_type ###
  * definition : define the content type to use ( this parameter is only available for drupal )
  * default value : "story"
### title ###
  * definition : default article title
  * default value : empty
  * example : "my first post from sl"
### categories ###
  * definition : default categories for the site
  * default value : 0
  * possible values : depending on the cms, the reactions are different.
    * wordpress : values are ids separated by commas
      * example : "1,2,3"
    * joomla : we can only define one value at the same time and the default category is 0
      * example : "0"
    * drupal : this parameter is not set for drupal because drupal is not using it
### publish status ###
  * definition : state of the article after posting
  * possible values :
    * TRUE or 1 : the article will be published
    * FALSE or 0 : the article will not be published
### use\_nl ###
  * definition : allow you to choose if we are using new lines for every line of the notecard or if we are using html tags for new lines.
  * possible values : TRUE or FALSE or bien 1 or 0
### body\_separator ###
  * definition : gives you the ability to custom the word that will separate the config from the content in the notecard.
  * default value : "<!--body-->"

# notecard examples #

```
title = My title from sl for wordpress
<!--body-->
Hello
here is my article header
<!--more-->
and here is the article body
```

```
title = My title for another wordpress site
url = http://myothersite.com/worpdress
categories = 1,5
use_nl = 0
<!--body-->
Here is another test
 that shows you
 that the lines are separated
 only if i am using a tag <br/>
 <p>but i can also use</p>
 <p>the tag p </p>
```


```
title = My title from sl for my drupal website
cms = drupal
url = http://mysite.com/drupal
username = toto
password = mypass
content_type = blog
<!--body-->
Here is my article teaser
<!--break-->
and here is my article body
```

```
title = My title from sl for my joomla website
url = http://mysite.com/joomla
username = titi
password = mypass
categories = 2
<!--body-->
Here is the header of my article
<hr id="system-readmore" />
and here is the body of my article
```