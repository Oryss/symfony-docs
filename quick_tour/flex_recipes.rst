Flex: Composez votre application
================================

Après avoir lu la première partie du tutorial, vous avez décidé que Symfony valait bien 10 minutes de plus. Bon choix ! Dans cette seconde partie, vous allez découvrir Symfony Flex : un outil incroyable qui simplifie l'ajout de nouvelles fonctionnalités. C'est aussi la raison pour laquelle Symfony est idéal pour des micro-services ou des grosses applications. Curieux ? Parfait !

Symfony: Commencer micro
------------------------

A moins que vous ne travailliez sur une API pure, vous voulez certainement faire du rendu de HTML. Pour cela, vous allez utiliser `Twig`_. Twig est un moteur de template pour PHP, flexible, rapide et sécurisé. Il rend vos templates plus lisible et concis; il les rend aussi plus accessible aux designers web?

Twig est-il déjà installé dans votre application ? Pas encore !
Lorsque vous démarrez un projet Symfony, elle est *légère* : seul les dépendances les plus critiques sont inclues dans le fichier ``composer.json`` :

.. code-block:: text

    "require": {
        "...",
        "symfony/console": "^4.1",
        "symfony/flex": "^1.0",
        "symfony/framework-bundle": "^4.1",
        "symfony/yaml": "^4.1"
    }

Cela rend Symfony différent des autres frameworks PHP ! Plutôt que de commencer *gros* avec *toutes* les fonctionnalités possibles, une application Symfony est petite, simple et *rapide*. Vous avez le contrôle total sur ce que vous souhaitez ajouter.

Recettes Flex et alias
----------------------

Comment peut-on installer et configurer Twig ? En exécutant cette commande :

.. code-block:: terminal

    $ composer require twig

Deux choses *très* intéressantes se déroulent en arrière plan, grâce à Symfony Flex : un plugin Composer déjà installé dans notre projet.
Premièrement, ``twig`` n'est pas le nom d'un package Composer : c'est un *alias* Flex qui pointe sur ``symfony/twig-bundle``. Flex traduit cette alias pour Composer.

Deuxièmement, Flex installe une *recette* (recipe) pour ``symfony/twig-bundle``. Qu'est-ce qu'une recette ?
C'est une manière, pour une librairie, de se configurer automatiquement en ajoutant et modifiant des fichiers. Grâce aux recettes, l'ajout de fonctionnalités se fait de manière automatique et homogène : installer un package et c'est terminé !

Vous pouvez trouver une liste complète des recettes et des alias sur `https://flex.symfony.com`_.

Qu'est-ce que cette recette a fait ? En plus d'automatiquement activer la fonctionnalité dans le fichier ``config/bundles.php``, elle a ajouté 3 choses :

``config/packages/twig.yaml``
    Un fichier de configuration avec les paramètres par défaut de Twig.

``config/routes/dev/twig.yaml``
    Une route qui vous aide lors du débug des pages d'erreur.

``templates/``
    Un dossier dans lequel vos fichiers de template vivent. La recette a également ajouté le fichier ``base.html.twig``.

Twig: Rendu d'un template (modèle)
----------------------------------

Grâce à Flex, après une commande, nous pouvons directement utiliser Twig :

.. code-block:: diff

    // src/Controller/DefaultController.php
    namespace App\Controller;

    use Symfony\Component\Routing\Annotation\Route;
    - use Symfony\Component\HttpFoundation\Response;
    + use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

    -class DefaultController
    +class DefaultController extends AbstractController
     {
         /**
          * @Route("/hello/{name}")
          */
         public function index($name)
         {
    -        return new Response("Hello $name!");
    +        return $this->render('default/index.html.twig', [
    +            'name' => $name,
    +        ]);
         }
    }

En héritant de ``AbstractController``, vous avez maintenant accès à un certain nombre de méthodes et outils, tel que ``render()``. Créer un nouveau template :

.. code-block:: html+twig

    {# templates/default/index.html.twig #}
    <h1>Hello {{ name }}</h1>

C'est tout : La syntaxe ``{{ name }}`` va afficher le contenu de la variable ``name`` qui est passée au contrôleur. Si vous découvrez Twig, bienvenue ! Vous en apprendrez plus sur sa syntaxe et ses possibilités plus tard.

Pour le moment, la page contient *uniquement* le tag ``h1``. Pour lui donner un modèle HTML, on peut hériter de  ``base.html.twig``:

.. code-block:: html+twig

    {# templates/default/index.html.twig #}
    {% extends 'base.html.twig' %}

    {% block body %}
        <h1>Hello {{ name }}</h1>
    {% endblock %}

C'est ce qu'on appelle l'héritage de template : notre page hérite de la structure HTML du fichier ``base.html.twig``.

Profiler: le paradis du débug
-----------------------------

Une des fonctionnalités les plus *cool* de Symfony n'est pas encore installé ! Réglons ça :

.. code-block:: terminal

    $ composer require profiler

Oui ! C'est un autre alias ! Et Flex installe *également* une autre recette, qui aide à automatiser la configuration du profiler de Symfony. Pour voir le résultat, rafraichissez la page !

Vous voyez cette barre noir en bas ? C'est la barre d'outils de débug web, et c'est votre nouveau meilleur ami. En passant la souris sur chaque icône, vous pouvez avoir des informations sur le contrôleur exécuté, les performances, le cache, et bien plus. Cliquer sur un icone pour vous rendre dans le *profiler* où vous obtiendrez des informations détaillées.

En installant plus de librairies, vous aurez accès à plus d'outils (tel que les informations sur les requêtes de base de données)

Vous pouvez utiliser le profiler directement car il s'est configuré *tout seul* grâce à la recette. Que pouvons-nous installer d'autre ?

Support API riche
-----------------

Vous développez une API ? Vous pouvez déjà retourner du JSON depuis n'importe quel contrôleur ::

    // src/Controller/DefaultController.php
    namespace App\Controller;

    use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
    use Symfony\Component\Routing\Annotation\Route;

    class DefaultController extends AbstractController
    {
        // ...

        /**
         * @Route("/api/hello/{name}")
         */
        public function apiExample($name)
        {
            return $this->json([
                'name' => $name,
                'symfony' => 'rocks',
            ]);
        }
    }

Mais pour une API réellement riche, essayez d'installer `API Platform`_:

.. code-block:: terminal

    $ composer require api

This is an alias to ``api-platform/api-pack`` :ref:`Symfony pack <symfony-packs>`,
which has dependencies on several other packages, like Symfony's Validator and
Security components, as well as the Doctrine ORM. In fact, Flex installed *5* recipes!

But like usual, we can immediately start using the new library. Want to create a
rich API for a ``product`` table? Create a ``Product`` entity and give it the
``@ApiResource()`` annotation::

    // src/Entity/Product.php
    namespace App\Entity;

    use ApiPlatform\Core\Annotation\ApiResource;
    use Doctrine\ORM\Mapping as ORM;

    /**
     * @ORM\Entity()
     * @ApiResource()
     */
    class Product
    {
        /**
         * @ORM\Id
         * @ORM\GeneratedValue(strategy="AUTO")
         * @ORM\Column(type="integer")
         */
        private $id;

        /**
         * @ORM\Column(type="string")
         */
        private $name;

        /**
         * @ORM\Column(type="int")
         */
        private $price;

        // ...
    }

Done! You now have endpoints to list, add, update and delete products! Don't believe
me? List your routes by running:

.. code-block:: terminal

    $ php bin/console debug:router

    ------------------------------ -------- -------------------------------------
     Name                           Method   Path
    ------------------------------ -------- -------------------------------------
     api_products_get_collection    GET      /api/products.{_format}
     api_products_post_collection   POST     /api/products.{_format}
     api_products_get_item          GET      /api/products/{id}.{_format}
     api_products_put_item          PUT      /api/products/{id}.{_format}
     api_products_delete_item       DELETE   /api/products/{id}.{_format}
     ...
    ------------------------------ -------- -------------------------------------

.. _ easily-remove-recipes:

Removing Recipes
----------------

Not convinced yet? No problem: remove the library:

.. code-block:: terminal

    $ composer remove api

Flex will *uninstall* the recipes: removing files and un-doing changes to put your
app back in its original state. Experiment without worry.

More Features, Architecture and Speed
-------------------------------------

I hope you're as excited about Flex as I am! But we still have *one* more chapter,
and it's the most important yet. I want to show you how Symfony empowers you to quickly
build features *without* sacrificing code quality or performance. It's all about
the service container, and it's Symfony's super power. Read on: about :doc:`/quick_tour/the_architecture`.

.. _`https://flex.symfony.com`: https://flex.symfony.com
.. _`API Platform`: https://api-platform.com/
.. _`Twig`: https://twig.symfony.com/
