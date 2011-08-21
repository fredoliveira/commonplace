# Commonplace

Commonplace is a plain and simple markdown-based wiki system. It works by reading markdown files from a directory you configure (my advice would be to keep this directory backed up through [Dropbox](http://getdropbox.com)) and serving those files in HTML. 

Commonplace is not meant to be a markdown editor. There are a number of tools that do that job extremely well - I happen to use [Byword](http://bywordapp.com) for Mac but you get to choose your own poison. Changes you do in your editor will reflect upon refresh. For now, consider Commonplace a beautiful way to browse the documents you create using your Markdown editor.

![Commonplace screenshot](http://madebyform.com/commonplace/img/screenshot.png)

## Installing Commonplace

Installing Commonplace is actually really easy. If you know your way around Apache, see the instructions below about Configuring apache. If you don't, here's what you do:

* Clone Commonplace to your local machine `git clone git://github.com/fredoliveira/commonplace.git`
* Edit the config file `config/commonplace.yml` to setup your wiki directory (for awesomeness, use somewhere inside your [Dropbox](http://getdropbox.com) folder to have constant syncing across your computers and automatic backups into the cloud)
* Create a `home.md` file inside your new wiki directory and type stuff in there. Markdown stuff. You know the drill.
* Install the shotgun gem to run Commonplace easily with `gem install shotgun`

## Running Commonplace

Once you're installed, running Commonplace is trivial.

* Head over to the directory where you installed commonplace
* Run it with `shotgun config.ru` and open `http://localhost:9393` in your browser
* You're done!

## Roadmap

* <del>Improve typography on the main page block</del>
* <del>Move configuration details to a separate file</del>
* <del>Create an easier way to run the wiki server</del>
* Allow users to edit pages in place and not just in their markdown editor
* Prettier error (500/404) pages

## Things for the advanced nerds

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