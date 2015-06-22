#!/bin/sh
export RAILS_ENV=demo
cd /home/app/webapp
bundle exec rake db:setup