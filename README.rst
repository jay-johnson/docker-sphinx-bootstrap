=========================
Docker + Sphinx Bootstrap
=========================

I built this repository_ for hosting my technical blog + resume + work portfolio. I containerized the sphinx-bootstrap_ repository so that on startup it will convert any ``rst`` files mounted from a host volume directory into themed, mobile-ready html. 

I use this repository for hosting and rendering ``rst`` as html on my blog:

http://jaypjohnson.com

Docker Hub Image: `jayjohnson/sphinx-bootstrap`_

Date: **2016-06-24**

.. role:: bash(code)
      :language: bash

Overview
--------

This project started because I wanted to write content and not worry about formatting. When the container starts it converts `reStructuredText Markup`_ ``rst`` files into readable, static html. It does this by using the `python Sphinx bootstrap`_ documentation generator built from `Sphinx`_ + `bootstrap`_. Once containerized, I could focus my time on content (like this post). As a fan of data-driven products, I added configurable integration points for `Google Analytics`_ and `Google Search Console`_. I like that out-of-the-box the sphinx-bootstrap-theme_ comes with support for `multiple bootswatch themes`_ and there are even more themes available from the `bootswatch repository`_ and `bootswatch website`_. Additionally it creates well-formatted, mobile-ready blost posts and web pages. 

Integrating with Google Analytics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Set your `Google Analytics Tracking Code`_ to the ENV_GOOGLE_ANALYTICS_CODE_ environment variable before container creation

   During container startup the environment variable ``ENV_GOOGLE_ANALYTICS_CODE`` will be `automatically installed into the default html layout`_ on every page across your site

Integrating with Google Search Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Automatic **sitemap.xml** creation

   When the container starts or you `manually rebuild the html content`_ it will `automatically build`_ a ``sitemap.xml`` from any files ending with a ``.rst`` extension in the repository's root directory. This file is stored in the environment variable ``ENV_DOC_OUTPUT_DIR`` directory. This is handy when you want to integrate your site into the `Google Search Console`_ and it should look similar to: http://jaypjohnson.com/sitemap.xml

.. _reStructuredText Markup: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
.. _python Sphinx bootstrap: https://github.com/ryan-roemer/sphinx-bootstrap-theme
.. _Sphinx: http://www.sphinx-doc.org/en/stable/
.. _sphinx-bootstrap-theme: https://github.com/ryan-roemer/sphinx-bootstrap-theme
.. _Google Analytics: https://analytics.google.com/
.. _Google Search Console: https://www.google.com/webmasters/tools/
.. _multiple bootswatch themes: https://github.com/ryan-roemer/sphinx-bootstrap-theme/blob/bfb28af310ad5082fae01dc1ff08dab6ab3fa410/demo/source/conf.py#L146-L150
.. _bootswatch website: http://bootswatch.com/
.. _bootswatch repository: https://github.com/thomaspark/bootswatch
.. _bootstrap: http://getbootstrap.com/
.. _docker compose: https://docs.docker.com/compose/
.. _manually rebuild the html content: https://github.com/jay-johnson/docker-sphinx-bootstrap/blob/2a752b96a7bcd378dbb207da1922c2e8997dc7ae/containerfiles/start-container.sh#L16-L17
.. _automatically build: https://github.com/jay-johnson/docker-sphinx-bootstrap/blob/2a752b96a7bcd378dbb207da1922c2e8997dc7ae/containerfiles/start-container.sh#L21-L41
.. _my blog: http://jaypjohnson.com
.. _jayjohnson/sphinx-bootstrap: https://hub.docker.com/r/jayjohnson/sphinx-bootstrap/
.. _Google Analytics Tracking Code: https://support.google.com/analytics/answer/1008080?hl=en
.. _ENV_GOOGLE_ANALYTICS_CODE: https://github.com/jay-johnson/docker-sphinx-bootstrap/blob/2a752b96a7bcd378dbb207da1922c2e8997dc7ae/Dockerfile#L47
.. _automatically installed into the default html layout: https://github.com/jay-johnson/docker-sphinx-bootstrap/blob/2a752b96a7bcd378dbb207da1922c2e8997dc7ae/containerfiles/start-container.sh#L13-L14

Getting Started
---------------

By default this container assumes there is a `sphinx-ready source`_ directory in ``/opt/blog/repo/``

Building
~~~~~~~~

To build the container you can run ``build.sh`` that automatically sources the properties.sh_ file:

::

    $ ./build.sh 
    Building new Docker image(docker.io/jayjohnson/sphinx-bootstrap)
    Sending build context to Docker daemon 48.64 kB
    Step 1 : FROM centos:7
     ---> 904d6c400333

    ...

    Removing intermediate container 4381745389cb
    Successfully built 724130d8b97f
    $

Here is the full command:

::
    
    docker build --rm -t <your name>/sphinx-bootstrap --build-arg registry=docker.io --build-arg maintainer=<your name> --build-arg imagename=sphinx-bootstrap .


Start the Container
~~~~~~~~~~~~~~~~~~~

To start the container run:

::

    $ ./start.sh 
    Starting new Docker image(docker.io/jayjohnson/sphinx-bootstrap)
    d321c432272cc61de3270ef302ef2f269610d70238274479bda711ef9d11c564
    $ 

Looking into the start.sh_ you can see that there are a few defaults taken from the properties.sh_ file:

::

    $ cat start.sh 
    #!/bin/bash

    source ./properties.sh .

    echo "Starting new Docker image($registry/$maintainer/$imagename)"
    docker run --name=$imagename -v /opt/blog:/opt/blog -d $maintainer/$imagename 

    exit 0
    $


Test the Container
~~~~~~~~~~~~~~~~~~

#. Check the container is running with:

   ::
    
       $ docker ps
       CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS               NAMES
       d321c432272c        jayjohnson/sphinx-bootstrap   "/root/containerfiles"   9 minutes ago       Up 9 minutes                            sphinx-bootstrap
       $


#. If the container started and generated the html correctly there should be a ``sitemap.xml`` file:

   ::

       $ ls /opt/blog/repo/release/sitemap.xml 
       /opt/blog/repo/release/sitemap.xml
       $
   

Environment Variables
~~~~~~~~~~~~~~~~~~~~~

If you are looking to configure the composition and containers, here are the available environment variables used by the containers:

+----------------------------------------+--------------------------------------------------------------------+-------------------------------------------------------------+ 
| Variable Name                          | Purpose                                                            | Default Value                                               | 
+========================================+====================================================================+=============================================================+ 
| **ENV_DEFAULT_ROOT_VOLUME**            | Path to shared volume for static html, js, css, images, and assets | /opt/blog                                                   | 
+----------------------------------------+--------------------------------------------------------------------+-------------------------------------------------------------+ 
| **ENV_DOC_SOURCE_DIR**                 | Input directory where Sphinx processes ``rst`` files               | /opt/blog/repo/source                                       | 
+----------------------------------------+--------------------------------------------------------------------+-------------------------------------------------------------+ 
| **ENV_DOC_OUTPUT_DIR**                 | Output directory where Sphinx will output the ``html`` files       | /opt/blog/repo/release                                      | 
+----------------------------------------+--------------------------------------------------------------------+-------------------------------------------------------------+ 
| **ENV_BASE_DOMAIN**                    | Your web domain like: ``http://jayjohnson.com``                    | http://jaypjohnson.com                                      | 
+----------------------------------------+--------------------------------------------------------------------+-------------------------------------------------------------+ 
| **ENV_GOOGLE_ANALYTICS_CODE**          | Your Google Analytics Tracking Code like: ``UA-79840762-99``       | UA-79840762-99                                              | 
+----------------------------------------+--------------------------------------------------------------------+-------------------------------------------------------------+ 


Want to add a new blog post?
----------------------------

#. Open a new ``new-post.rst`` file in the ``source`` directory

#. Add the following lines to the new ``new-post.rst`` file:

   ::

       ==================
       This is a New Post
       ==================
   
       My first blog post


#. Edit the ``index.rst`` file and find the ``Site Contents`` section

#. Add a new line to ``Site Contents`` **toctree** section containing: ``new-post`` 

   Here is how mine looks after adding it to the ``index.rst``

   ::

       Site Contents
       -------------

       .. toctree::
           :maxdepth: 2
   
           new-post
           python
           work-history
           contact
           about


   .. note:: One nice feature of the sphinx framework is it will automatically label the dropdown link with the first **Title** section found inside the file.

#. Save the ``index.rst`` file

#. Deploy and Rebuild the html files

   Inside the ``websphinx`` container I included a `deploy + rebuild script`_ you can run from outside the container with:

   ::

       $ docker exec -it websphinx /root/containerfiles/deploy-new-content.sh

#. Test the new post shows up in the site

   ::

       $ curl -s http://localhost:80/ | grep href | grep toctree | grep "New Post"
       <li class="toctree-l1"><a class="reference internal" href="new-post.html">This is a New Post</a></li>
       <li class="toctree-l1"><a class="reference internal" href="new-post.html">This is a New Post</a></li>
       $

Rebuilding HTML content without restarting the docker container
---------------------------------------------------------------

I added a rebuild-html.sh_ script that handles converting the ``rst`` files into html without a container restart. To rebuild the content for a new revision or deployment just run:

::

     $ ./rebuild-html.sh 
     Rebuilding HTML with command: /root/containerfiles/deploy-new-content.sh
     Done rebuilding html
     $ 

Stop the Container
~~~~~~~~~~~~~~~~~~

To stop the container run:

::

    $ ./stop.sh 
    Stopping Docker image(docker.io/jayjohnson/sphinx-bootstrap)
    sphinx-bootstrap
    $ 

Or run the command:

::
    
    docker stop sphinx-bootstrap


Licenses
--------

This repository is licensed under the MIT license.

Sphinx Bootstrap Theme is licensed under the MIT license.

Bootstrap v2 is licensed under the Apache license 2.0.

Bootstrap v3.1.0+ is licensed under the MIT license.


.. _repository: https://github.com/jay-johnson/docker-sphinx-bootstrap
.. _sphinx-bootstrap: https://hub.docker.com/r/jayjohnson/sphinx-bootstrap
.. _start.sh: https://github.com/jay-johnson/docker-sphinx-bootstrap/blob/master/start.sh
.. _start_container.sh: https://github.com/jay-johnson/docker-sphinx-bootstrap/blob/master/containerfiles/start-container.sh
.. _properties.sh: https://github.com/jay-johnson/docker-sphinx-bootstrap/blob/master/properties.sh
.. _sphinx-ready source: https://github.com/ryan-roemer/sphinx-bootstrap-theme/tree/master/demo
.. _rebuild-html.sh: https://github.com/jay-johnson/docker-sphinx-bootstrap/blob/master/rebuild-html.sh
.. _deploy + rebuild script: https://github.com/jay-johnson/docker-sphinx-bootstrap/blob/2a752b96a7bcd378dbb207da1922c2e8997dc7ae/containerfiles/deploy-new-content.sh


