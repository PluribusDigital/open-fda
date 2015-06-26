FROM stsilabs/openfda-web-base

#   Set correct environment variables.
ENV HOME /root

#   Load startup scripts
RUN mkdir -p /etc/my_init.d
ADD deploy/boot/initdb.sh /etc/my_init.d/initdb.sh
RUN chmod +x /etc/my_init.d/initdb.sh

#   Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

#   Expose Nginx HTTP service
EXPOSE 80

#   Configure nginx
ADD deploy/nginx/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD deploy/nginx/rails-env.conf /etc/nginx/main.d/rails-env.conf

#   Run Bundle in a cache efficient way
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

#   Add the rails app
RUN mkdir /home/app/webapp
ADD . /home/app/webapp
RUN chmod -R 0777 /home/app/webapp

#   Run python setup
WORKDIR /home/app/webapp/gruve
RUN python3 setup.py develop

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
