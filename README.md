# Commonplace

Commonplace is a plain and simple markdown-based wiki system. It works by reading markdown files from a directory you configure (my advice would be to keep this directory backed up through [Dropbox](http://getdropbox.com)) and serving those files in HTML. 

![Commonplace screenshot](http://cl.ly/3r29350l2x2A2j0f2Y40/Screen_Shot_2011-08-21_at_5.23.44_PM.png)

## Roadmap

* Improve typography on the main page block
* Create an easier way to run the wiki server

## Things for the nerds

### Configuring apache

If you already have Apache running on your machine, you can use passenger to serve Commonplace. While installing passenger is out of scope of this document, instructions [are available here](http://www.modrails.com/install.html). Once this is done, a VirtualHost entry like the one below (and a properly configured host - in the example below i use `wiki` as my host) should be all you need:

    <VirtualHost *:80>
        ServerName wiki
        DocumentRoot /Users/fred/Projects/personal/commonplace/public
    	RackEnv development
        <Directory /Users/fred/Projects/personal/commonplace>
            Allow from all
            Options -MultiViews
        </Directory>
    </VirtualHost>

### Running specs

There's a number of specs to test out the Commonplace functionality available on the `spec` directory. In order to run these tests, use the `rake` utility in the commonplace root folder. Green is good, red is bad. You shouldn't see any red.

You can also use `autotest` if you're so inclined. Running `autotest` in the commonplace root folder automatically monitors your spec files for changes and runs tests automatically. You can see the output in your terminal.