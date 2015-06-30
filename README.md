# OpenFDA


## Requirements
Prior to installation, you need the basics:
* ruby 2.1.5
* bundler
* PhantomJS 
  * See http://phantomjs.org/download.html
  * Note: the phantom team has not put out an NPM package, which is anticipated in version 2.1 https://github.com/Medium/phantomjs/issues/288
* nodejs & nodejs-legacy
  * `sudo apt-get install nodejs` and `sudo apt-get install nodejs-legacy`

## Installation
*Windows Users should perform the following steps using the Git Shell*

1. `npm install`
2. `rake db:reset`
3. `rake bower:install`

## Python Setup (one-time)
1. Install Python 3.x
2. Open a command line and navigate to the gruve directory
3. `python setup.py develop` (or `sudo python setup.py develop`)

Note: if you have multiple versions, you may need to specify python 3.x 
(i.e. `sudo python3.4 setup.py develop`)


# Approach

## Dev Stack
We use the following open source components (as well as additional plug-ins and modules)
 * PostgreSQL - Database
 * Python - ETL, specifically transformation-heavy
 * Ruby on Rails - Back End Web Application Framework
 * Bootstrap - HTML/CSS framework
 * AngularJS - Rich Client JavaScript Application Framework
 * Bootstrap.js - JavaScript widgets (as Angular Directives)
 * d3js - Charting & Visualization tools
We generally follow the style and conventions laid out in the http://angular-rails.com/ online book. 


### API Development Stack
 * Ruby on Rails - Namespaced controllers
 * jbuilder - robust templating
 * rspec request specs - integration testing of entire back end
 * Swagger - API documentation


## DevOps Stack
 * New Relic
 * CircleCI

Note: AWS vs. Heroku

### Dependency Management
We use Bundler, NPM and Bower (via bower-rails) to manage dependencies. See DEPENDENCY_README for more detail.













