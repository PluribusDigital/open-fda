# Setup

This file contains instructions to install and run the prototype.

## Requirements
Prior to installation, you need the basics:
* ruby 2.1.5
* python 3.x
* bundler
* PhantomJS 
  * See http://phantomjs.org/download.html
  * Note: the phantom team has not put out an NPM package, which is anticipated in version 2.1 https://github.com/Medium/phantomjs/issues/288
* nodejs & nodejs-legacy
  * `sudo apt-get install nodejs` and `sudo apt-get install nodejs-legacy`

## Installation

1. `npm install`
2. `rake db:reset`
3. `rake bower:install`

_Note: You'll need an [openFDA API key](https://open.fda.gov/api/reference/#your-api-key), and that needs to be in the `.env` file. (See `.env.example`). The app will run without supplying a New Relic key._

Then `rails server` to run the web app. 

*Windows Users should perform steps using the Git Shell (not windows command prompt).*

*Additional notes on dependency managmenet are in [doc/dependency_management.md](/doc/dependency_management.md)*

## Python Setup (one-time, optional)

The Python ETL scripts grab data from the openFDA API and some other sources, and stage the transformed data in .txt files. These .txt files are in the `data` directory of the repo to save the trouble of a long-running process. However, the "gruve" tool can re-create those .txt files.

1. `cd gruve`
2. `python setup.py develop` (or `sudo python setup.py develop`)

_Note: if you have multiple versions, you may need to specify python 3.x 
(i.e. `sudo python3.4 setup.py develop`)_

## Running Tests

* rspec `bundle exec rspec` (ruby unit tests, request specs, full stack feature specs)
* python `cd gruve then sudo python3.4 setup.py test` (unit tests for ETL scripts) - note: other python 3.x versions can be specified
* javascript `bundle exec rake teaspoon` (angular unit tests)

## Install via Docker Containers
This application can be deployed using the stsilabs/openfda-web docker image from dockerhub as well as the official standard postgres image (see https://registry.hub.docker.com/u/stsilabs/openfda-web/ and https://registry.hub.docker.com/_/postgres/). Deployments performed using this approach require only that the host server or service has Docker and Docker Compose installed.  

* Install Docker and Docker Compose on the host machine (see https://docs.docker.com/compose/install/).
* Setup environment variables
  1. `export OPENFDA_API_KEY=your-openfda-api-key`
  2. `export POSTGRES_PASSWORD=your-postgres-password`
* From the project root, launch Docker containers `docker-compose up -d`
* It takes several minutes for the application to seed its database.  During the seeding process the site will be  inaccessible.
