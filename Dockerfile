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

RUN echo "* * * * * root $CRON_FILE > /var/log/cron.log 2>&1" >> /etc/crontab
RUN touch /var/log/cron.log

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer

ADD run.sh /run.sh

CMD sh /run.sh
