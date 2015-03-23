Voici un script pour pouvoir poster des entrees de blog depuis sl.

Ces script fonctionne pour :
  * wordpress
  * drupal
  * joomla

Ce script est opensource, sinon j'ai fait une version amelioree seulement pour wordpress en vente [ici](http://www.xstreetsl.com/modules.php?name=Marketplace&file=item&ItemID=1261507)

Pour le faire fonctionner, il vous fait mettre ce script dans une boite et de creer une notecard.

Ensuite, il vous faut remplir les valeurs des 3 premieres variables du script :

  * username ( le nom de votre utilisateur sur le site )
  * password ( le mot de passe de cet utilisateur )
  * url ( l'adresse web de votre site. ex : http://monsite.com/wordpress

Lors de la creation de la notecard, on peut changer ces valeurs ( mais lorsque l'on change une valeur par notecard, celle ci reste en place donc il faut resetter le script pour revenir aux valeurs par defaut )
Cliquer sur l'objet pour faire apparaitre le menu de reset.

Les retours a la ligne fonctionnent ainsi que le contenu html.

Une fois la notecard creee, il suffit de la faire glisser sur la boite et un menu apparait apres analyse de la carte pour vous demander confirmation.
Ce script peut bien sur etre etendu en rajoutant les autres options de blogger mais la base est la.

**ATTENTION : LES LIGNES DE LA NOTECARD NE DOIVENT PAS DEPASSER 256 CARACTERES A CAUSE D'UNE LIMITATION DE SL**

# activation de xml rpc sur ses sites web #
Aller dans la partie administration de votre site et activer le xml-rpc

### activation pour wordpress ###
Pour wordpress ca se trouve sur la page : wp-admin/options-writing.php
### activation pour drupal ###
  * Installer le module qui se nomme : blogapi
  * aller dans admin/settings/blogapi et choisir le type de contenu à utiliser
  * aller dans admin/user/permissions et activer "administrer les contributions via le Blog API" pour le rôle utilisateur désiré
### activation pour joomla ###
    * Aller sur la page de config : administrator/index.php?option=com\_config et activer les "web services"
    * Aller dans la liste des plugins : administrator/index.php?option=com\_plugins&client=site et publier le plugin : XML-RPC - Blogger API

# configuration du script #
Vous pouvez definir des variables par defaut dans le script ou bien les mettre dans la notecard qui vous servira pour l'article.

Actuellement les variables sont :
### username ###
  * definition : nom d'utilisateur du site web
  * valeur par defaut : aucune
  * exemple : "toto"
### password ###
  * definition : mot de passe du site web
  * valeur par defaut : aucune
  * exemple : "titi"
### url ###
  * definition : url du site web
  * valeur par defaut : aucune
  * exemple : "http://monsiteweb.com/wordpress"
### cms ###
  * definition : le type de script utilise
  * valeur par defaut : "wordpress"
  * valeurs possibles :
    * wordpress
    * drupal
    * joomla
### content\_type ###
  * definition : definit le type de contenu de l'article.( ce parametre ne sert que pour drupal )
  * valeur par defaut : "story"
### title ###
  * definition : le titre de l'article par defaut
  * valeur par defaut : aucune
  * exemple : "mon premier post depuis sl"
### categories ###
  * definition : categories par defaut pour le site.
  * valeur par defaut : 0
  * valeurs possibles : selon le cms, les reactions sont differentes.
    * wordpress : les valeurs sont des ids separes par des virgules
      * exemple : "1,2,3"
    * joomla : on ne peut definir une seule categorie a la fois et la categorie par defaut est 0
      * exemple : "0"
    * drupal : ce parametre ne sert pas pour drupal car l'option n'est pas integree dans drupal
### publish status ###
  * definition : etat de l'article apres l'ecriture
  * valeurs possibles :
    * TRUE ou 1 : l'article sera publie
    * FALSE ou 0 : l'article ne sera pas publie
### use\_nl ###
  * definition : permet de choisir si on fait un retour a la ligne a chaque ligne de la notecard ou si on utilise les retours a la ligne en html.
  * valeurs possibles : TRUE ou FALSE ou bien 1 ou 0
### body\_separator ###
  * definition : permet de personnaliser le mot qui sert a separer la configuration du corps de l'article dans la notecard.
  * valeur par defaut : "<!--body-->"

# exemples de notecard #

```
title = Mon Titre depuis sl pour wordpress
<!--body-->
Bonjour
Voici l'en tete de mon aricle
<!--more-->
et voici le contenu de mon article
```

```
title = Mon titre depuis sl pour un autre site wordpress
url = http://monautresite.com/worpdress
categories = 1,5
use_nl = 0
<!--body-->
Ceci est un autre test
qui montre que les 
lignes seront separres
seulement si je mets une balise <br/>
<p>ou bien je peux utiliser</p>
<p>la balise p </p>
```


```
title = mon titre depuis sl pour mon site drupal
cms = drupal
url = http://monsitedrupal.com/drupal
username = toto
password = monpass
content_type = blog
<!--body-->
Voici l'en tete de mon article
<!--break-->
et voci le contenu de l'article
```

```
title = mon titre depuis sl pour mon site joomla
url = http://monsite.com/joomla
username = titi
password = monpass
categories = 2
<!--body-->
voici  l'en tete de mon article
<hr id="system-readmore" />
voici le corps de mon article
```