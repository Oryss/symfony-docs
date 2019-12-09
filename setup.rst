.. index::
   single: Installer & configurer le framework Symfony

Installer & configurer le framework Symfony
===========================================

.. _symfony-tech-requirements:

Prérequis technique
-------------------

Avant de créer votre première application Symfony, vous devez :

* Installer PHP 7.2.5 ou plus, et les extensions PHP suivantes (qui sont installés et activées par défaut dans la
plupart des installations de PHP 7) : `Ctype`_, `iconv`_, `JSON`_,
  `PCRE`_, `Session`_, `SimpleXML`_, et `Tokenizer`_;
* `Installer Composer`_, qui est utilisé pour installer les paquets PHP;
* `Installer Symfony`_, qui créer un exécutable sur votre ordinateur appelé ``symfony`` qui vous donne accès
à tous les outils nécessaires pour développer votre application localement.

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

L'unique différence entre ces deux commandes est le nombre de paquets installés par défaut. L'option ``--full``
istalle tous les paquets dont vous aurez besoin pour développer une application web traditionelle, l'installation
sera donc plus grosse.

Si vous ne pouvez, ou ne voulez pas `installer Symfony`_, lancez une de ces commandes pour créer votre application
Symfony en utilisant Composer :

.. code-block:: terminal

    # Pour une application web traditionelle
    $ composer create-project symfony/website-skeleton my_project_name

    # Pour un microservice, une application console ou une API
    $ composer create-project symfony/skeleton my_project_name

Peu importe la commande utilisée, un nouveau dossier ``my_project_name/`` sera crée, quelques dépendances à l'intérieur
 de ce dernier seront installés, les dossiers et fichiers basiques seront crées. En d'autres mots, votre nouvelle
 application est prête !

.. note::

    Le cache et les logs du projet (par défaut ``<projet>/var/cache/`` et ``<projet>/var/log/``) doit être accessible
    en écriture par votre serveur web. Si vous avez des problèmes à ce niveau, consultez la page :doc:`configurer les
     permissions d'une application Symfony </setup/file_permissions>`.

Lancer vos applications Symfony
-------------------------------

En production, vous devriez utiliser un serveur web tel que Nginx ou apache (voir
:doc:`configurer un serveur web pour faire fonctionner Symfony </setup/web_server_configuration>`).
Mais pour le développement, il est plus pratique d'utiliser le
:doc:`serveur web local</setup/symfony_server>` fournit par Symfony.

Le serveur local fournit un support pour le HTTP/2, TLS/SSL, la génération automatique des certificats de sécurité,
et plein d'autres fonctionnalités. Il fonctionne avec n'importe quel application PHP, non pas seulement pour les projets
 Symfony, c'est donc un outil de développement très utile.

Ouvrez votre terminal, placez vous dans le nouveau dossier du projet et lancez le serveur local :

.. code-block:: terminal

    $ cd my-project/
    $ symfony server:start

Ouvrez votre navigateur et rendez vous sur ``http://localhost:8000/``. Si tout fonctionne, vous verez une page
d'accueil. Lorsque vous souhaitez stopper le serveur, faites ``Ctrl+C`` dans le terminal.

.. _install-existing-app:

Mettre en place un projet Symfony existant
------------------------------------------

En plus de créer de nouveaux projets Symfony, vous allez également travailler sur des projets existants,
crées par d'autres développeurs. Dans ce cas, vous avez seulement besoin de récupérer le code du projet et installer
les dépendances avec Composer. En supposant que votre équipe utilise Git, installez le projet
avec les commandes suivantes :

.. code-block:: terminal

    # cloner le projet pour télécharger son contenu
    $ cd projects/
    $ git clone ...

    # faire que Composer installe les dépendances du projet dans le dossier vendor
    $ cd my-project/
    $ composer install

Vous aurez probablement besoin de customizer votre :ref:`fichier .env <config-dot-env>` et réaliser d'autres tâches
spécifiques à votre projet (par exemple, créer une base de données). Lorsque vous travaillez sur une application
Symfony existante pour la première fois, il peut être utile de lancer cette commande qui affiche des
informations à propos du projet :

.. code-block:: terminal

    $ php bin/console about

.. _symfony-flex:

Installer des paquets (packages)
--------------------------------

Une pratique courante lors du développement d'applications Symfony est d'installer des paquets
(Symfony les appelle :doc:`bundles </bundles>`) qui offrent des fonctionnalités toutes prêtes.
Les paquets nécessitent souvent des étapes d'installation avant de les utiliser (modifier un fichier pour activer
le bundle, créer un fichier de configuration, etc.)

La plupart du temps, ces étapes peuvent être automatisées et c'est là que `Symfony Flex`_ entre en jeu. C'est un outil
qui simplifie l'installation et la suppression des paquets dans les applications Symfony. Techniquement parlant,
Symfony Flex est un plugin Composer qui est installé par défaut lors de la création d'une application Symfony et qui
**automatique les tâches les plus courantes dans les applications Symfony**.

.. tip::

    Vous pouvez également :doc:`ajouter Symfony Flex à un projet existant </setup/flex>`.

Symfony Flex modifie le comportement des commandes Composer ``require``, ``update``, et
``remove`` pour fournir des fonctionnalités avancées. Par exemple :

.. code-block:: terminal

    $ cd my-project/
    $ composer require logger

Si vous exécutez cette commande dans une application Symfony qui n'utilisant pas Flex, vous verrez une erreur
Composer expliquant que ``logger`` n'est pas un nom de paquet valide. Par contre, si l'application inclut Flex,
cette commande installe et active les paquets nécessaires à l'utilisation du logger officiel de Symfony.

C'est possible car beaucoup de paquets/bundles Symfony définissent des **"recettes"** (recipes), qui
sont des collections d'instructions automatisées pour installer et activer des paquets dans des applications Symfony.
Flex garde trace des recettes installées dans un fichier ``symfony.lock``, qui doit être `commité`_ dans votre
dépôt Git.

Les recette Symfony Flex sont des contributions de la communauté et sont stockées
dans deux dépôts publics :

* `Dépôt de recettes principal`_, une liste de recettes vérifiées, de grande qualité et maintenues.
Par défaut, Symfony Flex va uniquement chercher dans ce dépôt.

* `Dépôt de recettes contrib`_, contient toutes les recettes crées par la communauté. Elles fonctionnent toutes,
mais leurs paquets associés pourraient ne plus être maintenues. Symfony Flex vous demandera votre permission
avant d'installer une de ces recettes.

Lisez la `Documentation recettes Symfony`_ pour apprendre tout sur la création de recettes pour vos propres paquets.

.. _symfony-packs:

Packs Symfony
~~~~~~~~~~~~~

Sometimes a single feature requires installing several packages and bundles.
Instead of installing them individually, Symfony provides **packs**, which are
Composer metapackages that include several dependencies.

For example, to add debugging features in your application, you can run the
``composer require --dev debug`` command. This installs the ``symfony/debug-pack``,
which in turn installs several packages like ``symfony/debug-bundle``,
``symfony/monolog-bundle``, ``symfony/var-dumper``, etc.

By default, when installing Symfony packs, your ``composer.json`` file shows the
pack dependency (e.g. ``"symfony/debug-pack": "^1.0"``) instead of the actual
packages installed. To show the packages, add the ``--unpack`` option when
installing a pack (e.g. ``composer require debug --dev --unpack``) or run this
command to unpack the already installed packs: ``composer unpack PACK_NAME``
(e.g. ``composer unpack debug``).

.. _security-checker:

Checking Security Vulnerabilities
---------------------------------

The ``symfony`` binary created when you `installer Symfony`_ provides a command to
check whether your project's dependencies contain any known security
vulnerability:

.. code-block:: terminal

    $ symfony check:security

A good security practice is to execute this command regularly to be able to
update or replace compromised dependencies as soon as possible. The security
check is done locally by cloning the public `Base de données de conseils de sécurité PHP`_,
so your ``composer.lock`` file is not sent on the network.

.. tip::

    The ``check:security`` command terminates with a non-zero exit code if
    any of your dependencies is affected by a known security vulnerability.
    This way you can add it to your project build process and your continuous
    integration workflows to make them fail when there are vulnerabilities.

Symfony LTS Versions
--------------------

According to the :doc:`Symfony release process </contributing/community/releases>`,
"long-term support" (or LTS for short) versions are published every two years.
Check out the `La roadmap de Symfony`_ to know which is the latest LTS version.

By default, the command that creates new Symfony applications uses the latest
stable version. If you want to use an LTS version, add the ``--version`` option:

.. code-block:: terminal

    # use the most recent LTS version
    $ symfony new my_project_name --version=lts

    # use the 'next' Symfony version to be released (still in development)
    $ symfony new my_project_name --version=next

The Symfony Demo application
----------------------------

`The Symfony Demo Application`_ is a fully-functional application that shows the
recommended way to develop Symfony applications. It's a great learning tool for
Symfony newcomers and its code contains tons of comments and helpful notes.

Run this command to create a new project based on the Symfony Demo application:

.. code-block:: terminal

    $ symfony new my_project_name --demo

Start Coding!
-------------

With setup behind you, it's time to :doc:`Create your first page in Symfony </page_creation>`.

Learn More
----------

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
.. _`L'application de demo Symfony`: https://github.com/symfony/demo
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
