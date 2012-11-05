## What is Commonplace?

*TL;DR:* A server for your markdown files. Give it a directory, and Commonplace gives you a url, pretty pages, and quick editing.

*The longer version:* I write quite a bit of Markdown, and usually keep my `.md` files scattered around my hard-drive. Commonplace is a simple sinatra-based server to browse and quickly edit your markdown files. It works by reading `.md` files from a directory you configure (my advice would be to keep this directory backed up through [Dropbox](http://getdropbox.com)). The name draws inspiration from [commonplace books](http://en.wikipedia.org/wiki/Commonplace_book).

Commonplace is not meant to be a markdown editor, even though it includes basic editing capabilities. There are a number of tools that do editing extremely well - I happen to use [Byword](http://bywordapp.com) for Mac but you get to choose your own poison. If you edit the markdown files in an external editor, changes are reflected in commonplace after refreshes.

![Commonplace screenshot](http://madebyform.com/commonplace/img/screen.png)

### Installing Commonplace

Installing Commonplace is actually really easy - all you need is ruby (which if you're on a fairly recent mac, you already have).

* Clone Commonplace to your local machine `git clone git://github.com/fredoliveira/commonplace.git`
* Install bundler, if you haven't got it yet `gem install bundler`
* Using bundler, install Commonplace's dependencies with `bundle install`
* Create `config/commonplace.yml`, based on the `commonplace.yml.example` file
* You're ready to start using Commonplace

### Running Commonplace

Once you're installed, running Commonplace is trivial.

* Head over to the directory where you installed commonplace, if you're not there already
* Run `shotgun config.ru` and open `http://localhost:9393` in your browser
* You're done, get cranking!

## Things for the advanced nerds

### Configuring options

You can edit the directory where Commonplace serves files from by editing the `config/commonplace.yml` file and restarting your server. For extra spice, use a directory somewhere inside your [Dropbox](http://getdropbox.com) folder to have constant syncing across your computers and automatic backups to the cloud. Delicious. As long as this directory has a `home.md` file inside which is used as the main entry point for Commonplace, you're all set.

### Using apache to host your Commonplace install

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

### Running the specs

There's a number of specs to test out the Commonplace functionality available on the `spec` directory. In order to run these tests, use the `rake` utility in the commonplace root folder. Green is good, red is bad. You shouldn't see any red.

You can also use `autotest` if you're so inclined. Running `autotest` in the commonplace root folder automatically monitors your spec files for changes and runs tests automatically. You can see the output in your terminal.