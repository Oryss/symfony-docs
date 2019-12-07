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
            return new Response('Bonjour !');
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

The URL to this page has changed: it is *now* ``/hello/*``: the ``{name}`` acts
like a wildcard that matches anything. And it gets better! Update the controller too:

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

Try the page out by going to ``http://localhost:8000/hello/Symfony``. You should
see: Hello Symfony! The value of the ``{name}`` in the URL is available as a ``$name``
argument in your controller.

But this can be even simpler! So let's install annotations support:

.. code-block:: terminal

    $ composer require annotations

Now, comment-out the YAML route by adding the ``#`` character:

.. code-block:: yaml

    # config/routes.yaml
    # index:
    #     path: /hello/{name}
    #     controller: 'App\Controller\DefaultController::index'

Instead, add the route *right above* the controller method:

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

This works just like before! But by using annotations, the route and controller
live right next to each other. Need another page? Add another route and method
in ``DefaultController``::

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

Routing can do *even* more, but we'll save that for another time! Right now, our
app needs more features! Like a template engine, logging, debugging tools and more.

Keep reading with :doc:`/quick_tour/flex_recipes`.

.. _`Composer`: https://getcomposer.org/
