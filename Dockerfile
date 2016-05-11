FROM ubuntu

# Basics
RUN apt-get update && apt-get install -y python-setuptools git curl

# PHP & nginx
RUN apt-get install -y php-cli php-fpm nginx
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php/7.0/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Install Composer
RUN (curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer)

# Copy site config
ADD .docker/nginx.conf /etc/nginx/sites-available/default

# Expose port
EXPOSE 80

# Run it
CMD ["sh", "-c", "cd /var/www/docklex && composer update && service php-fpm start && nginx"]
