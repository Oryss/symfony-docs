.. index::
   single: Installer & configurer le framework Symfony

Installer & configurer le framework Symfony
===========================================

.. _symfony-tech-requirements:

Prérequis technique
-------------------

Avant de créer votre première application Symfony, vous devez :

* Installer PHP 7.2.5 ou plus, et les extensions PHP suivantes (qui sont installés et activées par défaut dans la plupart des installations de PHP 7) : `Ctype`_, `iconv`_, `JSON`_, `PCRE`_, `Session`_, `SimpleXML`_, et `Tokenizer`_;
* `Installer Composer`_, qui est utilisé pour installer les paquets PHP;
* `Installer Symfony`_, qui créer un exécutable sur votre ordinateur appelé ``symfony`` qui vous donne accès à tous les outils nécessaires pour développer votre application localement.

L'exécutable ``symfony`` fournit un outil pour vérifier si votre machine répond aux exigences listées ci-dessus.
Ouvrez un terminal et exécutez la commande suivante :

.. code-block:: terminal

    $ symfony check:requirements

.. _creating-symfony-applications:

Créer des applications Symfony
------------------------------

Ouvrez votre terminal et lancez une de ces commandes pour créer une nouvelle application Symfony :

.. code-block:: terminal

    # Pour une application web traditionelle
    $ symfony new my_project_name --full

    # Pour un microservice, une application console ou une API
    $ symfony new my_project_name

L'unique différence entre ces deux commandes est le nombre de paquets installés par défaut. L'option ``--full`` installe tous les paquets dont vous aurez besoin pour développer une application web traditionelle, l'installation sera donc plus grosse.

Si vous ne pouvez, ou ne voulez pas `installer Symfony`_, lancez une de ces commandes pour créer votre application Symfony en utilisant Composer :

.. code-block:: terminal

    # Pour une application web traditionelle
    $ composer create-project symfony/website-skeleton my_project_name

    # Pour un microservice, une application console ou une API
    $ composer create-project symfony/skeleton my_project_name

Peu importe la commande utilisée, un nouveau dossier ``my_project_name/`` sera crée, quelques dépendances à l'intérieur de ce dernier seront installés, les dossiers et fichiers basiques seront crées. En d'autres mots, votre nouvelle application est prête !

.. note::

    Le cache et les logs du projet (par défaut ``<projet>/var/cache/`` et ``<projet>/var/log/``) doit être accessible en écriture par votre serveur web. Si vous avez des problèmes à ce niveau, consultez la page :doc:`configurer les permissions d'une application Symfony </setup/file_permissions>`.

Lancer vos applications Symfony
-------------------------------

En production, vous devriez utiliser un serveur web tel que Nginx ou apache (voir :doc:`configurer un serveur web pour faire fonctionner Symfony </setup/web_server_configuration>`). Mais pour le développement, il est plus pratique d'utiliser le :doc:`serveur web local</setup/symfony_server>` fournit par Symfony.

Le serveur local fournit un support pour le HTTP/2, TLS/SSL, la génération automatique des certificats de sécurité, et plein d'autres fonctionnalités. Il fonctionne avec n'importe quel application PHP, non pas seulement pour les projets Symfony, c'est donc un outil de développement très utile.

Ouvrez votre terminal, placez vous dans le nouveau dossier du projet et lancez le serveur local :

.. code-block:: terminal

    $ cd my-project/
    $ symfony server:start

Ouvrez votre navigateur et rendez vous sur ``http://localhost:8000/``. Si tout fonctionne, vous verez une page d'accueil. Lorsque vous souhaitez stopper le serveur, faites ``Ctrl+C`` dans le terminal.

.. _install-existing-app:

Mettre en place un projet Symfony existant
------------------------------------------

En plus de créer de nouveaux projets Symfony, vous allez également travailler sur des projets existants, crées par d'autres développeurs. Dans ce cas, vous avez seulement besoin de récupérer le code du projet et installer les dépendances avec Composer. En supposant que votre équipe utilise Git, installez le projet avec les commandes suivantes :

.. code-block:: terminal

    # cloner le projet pour télécharger son contenu
    $ cd projects/
    $ git clone ...

    # faire que Composer installe les dépendances du projet dans le dossier vendor
    $ cd my-project/
    $ composer install

Vous aurez probablement besoin de customizer votre :ref:`fichier .env <config-dot-env>` et réaliser d'autres tâches spécifiques à votre projet (par exemple, créer une base de données). Lorsque vous travaillez sur une application Symfony existante pour la première fois, il peut être utile de lancer cette commande qui affiche des informations à propos du projet :

.. code-block:: terminal

    $ php bin/console about

.. _symfony-flex:

Installer des paquets (packages)
--------------------------------

Une pratique courante lors du développement d'applications Symfony est d'installer des paquets (Symfony les appelle :doc:`bundles </bundles>`) qui offrent des fonctionnalités toutes prêtes. Les paquets nécessitent souvent des étapes d'installation avant de les utiliser (modifier un fichier pour activer le bundle, créer un fichier de configuration, etc.)

La plupart du temps, ces étapes peuvent être automatisées et c'est là que `Symfony Flex`_ entre en jeu. C'est un outil qui simplifie l'installation et la suppression des paquets dans les applications Symfony. Techniquement parlant, Symfony Flex est un plugin Composer qui est installé par défaut lors de la création d'une application Symfony et qui **automatise les tâches les plus courantes dans les applications Symfony**.

.. tip::

    Vous pouvez également :doc:`ajouter Symfony Flex à un projet existant </setup/flex>`.

Symfony Flex modifie le comportement des commandes Composer ``require``, ``update``, et ``remove`` pour fournir des fonctionnalités avancées. Par exemple :

.. code-block:: terminal

    $ cd my-project/
    $ composer require logger

Si vous exécutez cette commande dans une application Symfony qui n'utilisant pas Flex, vous verrez une erreur Composer expliquant que ``logger`` n'est pas un nom de paquet valide. Par contre, si l'application inclut Flex, cette commande installe et active les paquets nécessaires à l'utilisation du logger officiel de Symfony.

C'est possible car beaucoup de paquets/bundles Symfony définissent des **"recettes"** (recipes), qui sont des collections d'instructions automatisées pour installer et activer des paquets dans des applications Symfony. Flex garde trace des recettes installées dans un fichier ``symfony.lock``, qui doit être `commité`_ dans votre dépôt Git.

Les recette Symfony Flex sont des contributions de la communauté et sont stockées dans deux dépôts publics :

* `Dépôt de recettes principal`_, une liste de recettes vérifiées, de grande qualité et maintenues. Par défaut, Symfony Flex va uniquement chercher dans ce dépôt.

* `Dépôt de recettes contrib`_, contient toutes les recettes crées par la communauté. Elles fonctionnent toutes, mais leurs paquets associés pourraient ne plus être maintenues. Symfony Flex vous demandera votre permission avant d'installer une de ces recettes.

Lisez la `Documentation recettes Symfony`_ pour apprendre tout sur la création de recettes pour vos propres paquets.

.. _symfony-packs:

Packs Symfony
~~~~~~~~~~~~~

Des fois, une seule fonctionnalité requiert l'installation de plusieurs paquets et bundles. Plutôt que de les installer individuellement, Symfony fournit des **packs**, qui sont des metapaquets Composer incluant plusieurs dépendances.

Par exemple, pour ajouter des fonctionnalités de débug à votre application, vous pouvez lancer la commande ``composer require --dev debug``. Cela va installer le ``symfony/debug-pack`` qui va à son tour installer ``symfony/debug-bundle``, ``symfony/monolog-bundle``, ``symfony/var-dumper``, etc.

Par défaut, lors de l'installation de packs, votre fichier ``composer.json`` affiche les dépendances du pack (exemple ``"symfony/debug-pack": "^1.0"``) plutôt que les paquets installés. Pour afficher les paquets, ajoutez l'option ``--unpack`` en installant le pack (``composer require debug --dev --unpack``) ou lancer cette commande pour unpack des packs déjà installés : ``composer unpack PACK_NAME`` (exemple ``composer unpack debug``).

.. _security-checker:

Vérifier les vulnérabilités de sécurité
---------------------------------------

L'exécutable ``symfony`` crée lorsque vous installez Symfony fournit une commande pour vérifier si les dépendances de votre projet contiennent des vulnérabilités connues :

.. code-block:: terminal

    $ symfony check:security

Une bonne pratique de sécurité est d'exécuter cette commande régulièrement pour pouvoir mettre à jour ou remplacer des dépendances compromises le plus tôt possible. La vérification de sécurité est faite en local en clonant la `Base de données de conseils de sécurité PHP`_, votre ``composer.lock`` ne transite donc pas sur le réseau.

.. tip::

    La commande ``check:security`` se termine avec un code de sortie différent de zéro si une de vos dépendances est affectée par une vulnérabilité connu. Vous pouvez donc l'ajouter à votre process de build et votre intégration continue pour qu'ils ne passent pas en cas de vulnérabilité.

Les versions LTS de Symfony
---------------------------

Selon le :doc:`processus de release de Symfony </contributing/community/releases>`, les versions "long-term support" (support de long terme) (ou LTS) sont publiées tous les deux ans. Vous pouvez vous rendre sur `La roadmap de Symfony`_ pour savoir quelle version est la dernière LTS.

Par défaut, la commande pour créer une nouvelle application Symfony utilise la dernière version stable. Si vou souhaitez utiliser une LTS, ajoutez l'option ``--version`` :

.. code-block:: terminal

    # utilise la LTS la plus récente
    $ symfony new my_project_name --version=lts

    # utilise la 'prochaine' version de Symfony qui sera publiée (encore en développement)
    $ symfony new my_project_name --version=next

L'application Symfony de démonstration
--------------------------------------

`L'application Symfony de démonstration`_ est une application complétement fonctionnelle qui montre la manière recommandée pour développer des applications Symfony. C'est un très bon outil d'apprentissage pour les néophites de Symfony et son code contient plein de commentaires et de notes utiles.

Exécutez cette commande pour créer un nouveau projet basé sur l'application de démonstration :

.. code-block:: terminal

    $ symfony new my_project_name --demo

Commencez à coder !
-------------------

Il est temps de commencer à :doc:`créer votre première page avec Symfony </page_creation>`

En apprendre plus
-----------------

.. toctree::
    :hidden:

    page_creation

.. toctree::
    :maxdepth: 1
    :glob:

    setup/homestead
    setup/web_server_configuration
    setup/*

.. _`Installer Composer`: https://getcomposer.org/download/
.. _`Installer Symfony`: https://symfony.com/download
.. _`L'application Symfony de démonstration`: https://github.com/symfony/demo
.. _`Symfony Flex`: https://github.com/symfony/flex
.. _`Base de données de conseils de sécurité PHP`: https://github.com/FriendsOfPHP/security-advisories
.. _`La roadmap de Symfony`: https://symfony.com/roadmap
.. _`Dépôt de recettes principal`: https://github.com/symfony/recipes
.. _`Dépôt de recettes contrib`: https://github.com/symfony/recipes-contrib
.. _`Documentation recettes Symfony`: https://github.com/symfony/recipes/blob/master/README.rst
.. _`iconv`: https://php.net/book.iconv
.. _`JSON`: https://php.net/book.json
.. _`Session`: https://php.net/book.session
.. _`Ctype`: https://php.net/book.ctype
.. _`Tokenizer`: https://php.net/book.tokenizer
.. _`SimpleXML`: https://php.net/book.simplexml
.. _`PCRE`: https://php.net/book.pcre
.. _`commité`: https://en.wikipedia.org/wiki/Commit_(version_control)
