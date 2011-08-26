## What is Commonplace?

I write quite a bit, usually in Markdown, but I usually keep all my markdown files scattered around my hard-drive. Commonplace is a simple wiki-like system to store and browse your markdown files. It works by reading `.md` files from a directory you configure (my advice would be to keep this directory backed up through [Dropbox](http://getdropbox.com)). The name draws inspiration from [commonplace books](http://en.wikipedia.org/wiki/Commonplace_book).

Commonplace is not meant to be a markdown editor, even though it includes basic editing capabilities. There are a number of tools that do the markdown editing job extremely well - I happen to use [Byword](http://bywordapp.com) for Mac but you get to choose your own poison. If you edit the markdown files in an external editor, changes are reflected here after a refresh.

![Commonplace screenshot](http://madebyform.com/commonplace/img/screen.png)

### Installing Commonplace

Installing Commonplace is actually really easy - all you need is ruby (which if you're on a fairly recent mac, you already have). If you know your way around Apache, see the instructions below about Configuring apache. If you don't, here's what you do:

* Clone Commonplace to your local machine `git clone git://github.com/fredoliveira/commonplace.git`
* Install bundler, if you haven't got it yet `gem install bundler`
* Using bundler, install Commonplace's dependencies with `bundle install`
* You're ready to start using Commonplace

### Running Commonplace

Once you're installed, running Commonplace is trivial.

* Head over to the directory where you installed commonplace, if you're not there already
* Run `shotgun config.ru` and open `http://localhost:9393` in your browser
* You're done, get cranking!

### Roadmap

* <del>Prettier error (500/404) pages</del>
* <del>Improve typography on the main page block</del>
* <del>Allow users to edit pages in place and not just in their markdown editor</del>
* <del>Create an easier way to run the wiki server</del>
* <del>Create a basic wiki folder with info on running / getting started</del>
* <del>Move configuration details to a separate file</del>
* <del>Create a syntax to link between Markdown documents (probably `[[like this]]`)</del>
* <del>Link pages that don't exist differently</del>
* Reorganize classes and modules

### Making-of

* Commonplace makes use of [Twitter's Bootstrap](https://github.com/twitter/bootstrap/) toolkit

## Things for the advanced nerds

### Configuring options

You can edit the directory where Commonplace serves files from by editing the `config/commonplace.yml` file and restarting your server. For awesomeness, use a directory somewhere inside your [Dropbox](http://getdropbox.com) folder to have constant syncing across your computers and automatic backups into the cloud. Delicious. As long as this directory has a `home.md` file inside which is used as the main entry point for Commonplace, you're all set.

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

### Running specs

There's a number of specs to test out the Commonplace functionality available on the `spec` directory. In order to run these tests, use the `rake` utility in the commonplace root folder. Green is good, red is bad. You shouldn't see any red.

You can also use `autotest` if you're so inclined. Running `autotest` in the commonplace root folder automatically monitors your spec files for changes and runs tests automatically. You can see the output in your terminal.

## Contributing

This being an open source project, you are quite welcome to contribute by sending in your patches and pull requests - I'm quite open to that, as long as you don't detract Commonplace from the main goal of being simple, clean and objective. 

If you want to contribute financially because you find this to be a neat tool (which makes me quite glad, I'll say), please consider donating 1 dollar per day to [Save the Children](http://www.savethechildren.org/) (or your favorite charity) instead. I'm fortunate enough to be able to do this for free, and there's people who'd make better use of your hard earned money. Thank you!