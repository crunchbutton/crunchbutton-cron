FROM php:7.0-fpm

ADD run.sh /run.sh

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

RUN touch /var/log/cron.log

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

CMD sh /run.sh
