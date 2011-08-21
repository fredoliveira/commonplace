# Commonplace

Commonplace is a plain and simple markdown-based wiki system. It works by reading markdown files from a directory you configure (my advice would be to keep this directory backed up through [Dropbox](http://getdropbox.com)) and serving those files in HTML. 

## Things for the nerds

### Running specs

There's a number of specs to test out the Commonplace functionality available on the `spec` directory. In order to run these tests, change into the spec directory and use `rspec` to run them. 

    cd spec
    rspec --color --format doc commonplace_spec.rb

Green is good, red is bad. You shouldn't see any red.