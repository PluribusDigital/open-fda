#!/bin/sh
cd /home/app/webapp
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed