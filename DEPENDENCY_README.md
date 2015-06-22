# Dependency Management

## Bundler - Ruby Dependencies
 * /gemfile
 * `bundle install` to install packages
 * Docs: http://bundler.io/

## NPM - Node Modules
 * /package.json defines node dependencies (i.e. bower)
 * `npm install` to install packages (or `sudo npm install`)
 * Docs: https://github.com/npm/npm

## Bower & bower-rails - Front-end (js/css/html) Dependencies
 * /bower.json defines dependencies
 * For this project we use *bower-rails*, which generally let's the front-end libraries play nice with the rails asset pipeline (e.g. which directory to install to)
 * `rake bower:install` to install packages
 * Docs: http://bower.io/
 * Docs: https://github.com/rharriso/bower-rails

