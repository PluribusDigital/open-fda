FROM phusion/passenger-ruby21:0.9.15

#   Set correct environment variables.
ENV HOME /root

#   Initialize database as part of container startup
RUN mkdir -p /etc/my_init.d
ADD deploy/boot/initdb.sh /etc/my_init.d/initdb.sh
RUN chmod +x /etc/my_init.d/initdb.sh

#   Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

#   Build system and git.
#   NOTE  - passenger docker documentation incorrectly lists "pb_build" as the build directory
#RUN /build/utilities.sh
#   Ruby support.
#RUN /build/ruby2.1.sh
#   Python support.
#RUN /build/python.sh
#   Node.js and Meteor support.
#RUN /build/nodejs.sh

#   Expose Nginx HTTP service
EXPOSE 80

#   Enable nginx 
RUN rm -f /etc/service/nginx/down

#   Remove default site
RUN rm /etc/nginx/sites-available/default

#   Configure nginx
ADD deploy/nginx/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD deploy/nginx/rails-env.conf /etc/nginx/main.d/rails-env.conf

#   Run Bundle in a cache efficient way
#WORKDIR /tmp
#ADD Gemfile /tmp/
#ADD Gemfile.lock /tmp/
#RUN bundle install

#   Add the rails app
RUN mkdir /home/app/webapp
ADD . /home/app/webapp
RUN chmod -R 0777 /home/app/webapp
WORKDIR /home/app/webapp
RUN bundle install

#   Install npm
WORKDIR /home/app/webapp
RUN npm install

#   Install bower
RUN bundle exec rake bower:install['--allow-root']


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
