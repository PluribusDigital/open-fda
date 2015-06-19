FROM phusion/passenger-customizable:0.9.14

#   Set correct environment variables.
ENV HOME /root

#   Initialize database as part of container startup
RUN mkdir -p /etc/my_init.d
ADD boot/initdb.sh /etc/my_init.d/initdb.sh

#   Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

#   Build system and git.
#   NOTE  - passenger docker documentation incorrectly lists "pb_build" as the build directory
RUN /build/utilities.sh
#   Ruby support.
RUN /build/ruby2.1.sh
#   Python support.
RUN /build/python.sh
#   Node.js and Meteor support.
RUN /build/nodejs.sh

# Expose Nginx HTTP service
EXPOSE 80

#   Enable nginx 
RUN rm -f /etc/service/nginx/down

#   Remove default site
RUN rm /etc/nginx/sites-enabled/default

#   Configure nginx
ADD deploy/nginx/webapp.conf /etc/nginx/sites-enabled/webapp.conf
RUN mkdir /home/app/webapp

#   Run Bundle in a cache efficient way
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

#   Add the rails app
ADD . /home/app/webapp



# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*