Vue d'ensemble
==============

Commencez  à utiliser Symfony en 10 minutes ! Vraiment ! C'est tout ce dont vous avez besoin pour comprendre les concepts les plus importants et comment à créer de vrais projets !

Si vous avez déjà utilisé un framework web, vous devriez vous sentir en terrain connu avec Symfony. Sinon, bienvenue dans une toute nouvelle manière de développer des applications web. Symfony applique les bonnes pratiques, ne casse pas la retrocompatibilité (Mettre à jour est facile et sûr) et offre un support sur le long terme.

.. _installing-symfony2:

Télécharger Symfony
-------------------

Avant toute chose, vous devez avoir installé `Composer`_ et avoir PHP 7.1.3 ou plus.

Prêt ? Dans votre terminal, lancer :

.. code-block:: terminal

    $ composer create-project symfony/skeleton quick_tour

Cela créer un nouveau dossier ``quick_tour/`` avec une petite (mais puissante) application Symfony :

.. code-block:: text

    quick_tour/
    ├─ .env
    ├─ bin/console
    ├─ composer.json
    ├─ composer.lock
    ├─ config/
    ├─ public/index.php
    ├─ src/
    ├─ symfony.lock
    ├─ var/
    └─ vendor/

Peut-on déjà lancer le projet dans un navigateur ? Oui ! Vous pouvez installer :doc:`Nginx ou Apache </setup/web_server_configuration>` et configurer leur racine sur le dossier ``public/``. Mais pour le développement, il est plus pratique :doc:`d'installer le serveur Symfony local</setup/symfony_server>` et le lancer avec la commande suivante :

.. code-block:: terminal

    $ symfony server:start

Essayez votre application en vous rendant sur ``http://localhost:8000`` dans un navigateur !

.. image:: /_images/quick_tour/no_routes_page.png
   :align: center
   :class: with-browser

Fondamentaux : Route, Contrôleur, Réponse
-----------------------------------------

Notre projet ne contient que 15 fichiers, mais il est prêt à devenir une API, une application web robute ou un microservice. Symfony commence petit, mais s'adapte à votre progression.

Avant d'aller trop loin, découvrons déjà les fondamentaux en créant notre première page.

Commençons dans le fichier ``config/routes.yaml`` : c'est ici que vous pouvez définir l'URL de notre nouvelle page. Décommentez la ligne d'exemple qui se trouve dans le fichier :

.. code-block:: yaml

    # config/routes.yaml
    index:
        path: /
        controller: 'App\Controller\DefaultController::index'

C'est une *route* : elle définit l'URL de notre page (``/``) et le "controller" : la fonction qui sera appellée lorsqu'une personne visite l'URL. Cette fonction n'existe pas, nous pouvons la créer !

Dans ``src/Controller``, créer une nouvelle classe ``DefaultController`` et une méthode ``index``
à l'intérieur::

    // src/Controller/DefaultController.php
    namespace App\Controller;

    use Symfony\Component\HttpFoundation\Response;

    class DefaultController
    {
        public function index()
        {
            return new Response('Hello!');
        }
    }

C'est tout ! Essayez d'aller sur la page d'accueil : ``http://localhost:8000/``. Symfony voit que l'URL correspond à notre route et exécute la nouvelle méthode ``index()``.

Un contrôleur est juste une fonction normale avec une unique règle : elle doit retourner un objet Symfony de type ``Response``. Mais cette réponse peut être n'importe quoi : du texte, du JSON ou une page HTML complète.

Le système de routage est *beaucoup* plus puissant. Créons une route plus intéressante :

.. code-block:: diff

    # config/routes.yaml
    index:
    -     path: /
    +     path: /hello/{name}
        controller: 'App\Controller\DefaultController::index'

L'URL a changé : c'est maintenant ``/hello/*`` : le ``{name}`` correspond à un caractère de remplacement qui match avec n'importe quoi. Modifiez également le contrôleur :

.. code-block:: diff

    // src/Controller/DefaultController.php
    namespace App\Controller;

    use Symfony\Component\HttpFoundation\Response;

    class DefaultController
    {
    -     public function index()
    +     public function index($name)
        {
    -         return new Response('Hello!');
    +         return new Response("Hello $name!");
        }
    }

Allez sur la page ``http://localhost:8000/hello/Symfony``. Vous devriez voir : Hello Symfony! La valeur de ``{name}`` dans l'URL est disponible en tant qu'argument dans le contrôleur.

On peut encore simplifier ! Installons le support pour les annotations :

.. code-block:: terminal

    $ composer require annotations

Commentez la route du fichier YAML en ajoutant des ``#`` :

.. code-block:: yaml

    # config/routes.yaml
    # index:
    #     path: /hello/{name}
    #     controller: 'App\Controller\DefaultController::index'

Ajoutez la route juste au dessus de la méthode du contrôleur :

.. code-block:: diff

    // src/Controller/DefaultController.php
    namespace App\Controller;

    use Symfony\Component\HttpFoundation\Response;
    + use Symfony\Component\Routing\Annotation\Route;

    class DefaultController
    {
    +    /**
    +     * @Route("/hello/{name}")
    +     */
         public function index($name) {
             // ...
         }
    }

Cela fonctionne comme avant ! En utilisant les annotations, la route et le contrôleur sont l'un à coté de l'autre. Vous avez besoin d'une autre page ? Ajoutez une autre route et une méthode dans ``DefaultController``::

    // src/Controller/DefaultController.php
    namespace App\Controller;

    use Symfony\Component\HttpFoundation\Response;
    use Symfony\Component\Routing\Annotation\Route;

    class DefaultController
    {
        // ...

        /**
         * @Route("/simplicity")
         */
        public function simple()
        {
            return new Response('Simple! Easy! Great!');
        }
    }

Le routage peut faire *encore* plus, mais nous découvrirons ça plus tard ! Pour l'instant, notre application nécessite plus de fonctionnalités : un moteur de template, du logging, des outils de débug, etc.

Continuez à lire la documentation ici :doc:`/quick_tour/flex_recipes`.

.. _`Composer`: https://getcomposer.org/
