FROM php:7.0-fpm

RUN apt-get update && apt-get install -y \
	gnome-schedule \
	libmcrypt-dev \
	php-pear \
	curl \
	git \
	zlib1g-dev \
	&& docker-php-ext-install iconv mcrypt \
	&& docker-php-ext-install pdo pdo_mysql \
	&& docker-php-ext-install mbstring \
	&& docker-php-ext-install zip

RUN echo "* * * * * root /app/cli/master_cron.sh > /var/log/cron.log 2>&1" >> /etc/crontab
RUN touch /var/log/cron.log

RUN cd /app && curl -sS https://getcomposer.org/installer | php
RUN cd /app && php composer.phar install --no-dev --optimize-autoloader --prefer-dist

ADD run.sh /run.sh

CMD sh /run.sh
