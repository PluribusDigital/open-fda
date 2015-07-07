# Dependency Management

## Bundler - Ruby Dependencies
 * `Gemfile` defines Ruby dependencies
 * `bundle install` to install packages
 * Docs: http://bundler.io/

## NPM - Node Modules
 * `/package.json` defines node dependencies (i.e. bower)
 * `npm install` to install packages (or `sudo npm install`)
 * Docs: https://github.com/npm/npm

## Bower & bower-rails - Frontend (js/css/html) Dependencies
 * `/bower.json` defines frontend dependencies
 * For this project we use *bower-rails*, which generally let's the front-end libraries play nice with the rails asset pipeline (e.g. which directory to install to)
 * `rake bower:install` to install packages
 * Docs: http://bower.io/
 * Docs: https://github.com/rharriso/bower-rails

## Python - ETL Dependencies
 * `/gruve/setup.py` defines dependencies (i.e. requests)
 * To install packages:
   1. `cd gruve` 
   2. Based on the environment:
     1. Developer - `python setup.py develop`
     2. Test or Production - `python setup.py install`
 * Docs: https://packaging.python.org/en/latest/distributing.html
