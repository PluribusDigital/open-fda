FROM phusion/passenger-ruby21:0.9.15

#   Set correct environment variables.
ENV HOME /root

#   Load startup scripts
RUN mkdir -p /etc/my_init.d
ADD deploy/init/initdb.sh /etc/my_init.d/initdb.sh
RUN chmod +x /etc/my_init.d/initdb.sh

#   Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

#   Expose Nginx HTTP service
EXPOSE 80

#   Enable nginx 
RUN rm -f /etc/service/nginx/down

#   Remove default site
RUN rm /etc/nginx/sites-available/default

#   Configure nginx
ADD deploy/nginx/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD deploy/nginx/rails-env.conf /etc/nginx/main.d/rails-env.conf

#   Install AWS tools
RUN apt-get update
RUN apt-get install zip -y
RUN apt-get install --reinstall ca-certificates
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

#   Add the rails app
RUN mkdir -p /home/app/webapp
ADD . /home/app/webapp
RUN chmod -R 0777 /home/app/webapp

#   Run Bundle
WORKDIR /home/app/webapp
RUN bundle install --without development test

#   Run python setup
RUN apt-get -y -q install python3-setuptools
WORKDIR /home/app/webapp/gruve
RUN python3 setup.py develop

#   Install npm
WORKDIR /home/app/webapp
RUN npm install

#   Install bower
RUN bundle exec rake bower:install['--allow-root']

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
