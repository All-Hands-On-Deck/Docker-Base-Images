FROM php:7.2-apache
MAINTAINER Andre Marcelo-Tanner <andre@galleon.ph>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
       git \
       wget \
       lsb-release \
       apt-transport-https \
       ssl-cert \
       supervisor \
       gnupg \
    && curl -LO https://dev.mysql.com/get/mysql-apt-config_0.8.8-1_all.deb \
    && dpkg -i mysql-apt-config_0.8.8-1_all.deb \
    && rm mysql-apt-config_0.8.8-1_all.deb \
    && curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && echo "deb https://deb.nodesource.com/node_6.x $(lsb_release -cs) main" >> /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y \
       nodejs \
       libfontconfig1-dev \
       libfreetype6-dev \
       libjpeg62-turbo-dev \
       libpng12-dev \
       libxml2-dev \
       libbz2-dev \
       libmysqlclient-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/inculde --with-jpeg-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) bcmath bz2 json gd mbstring mysqli opcache pdo_mysql xml zip \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && npm install -g bower \
    && a2enmod rewrite ssl \
    && a2ensite default-ssl

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
      echo 'opcache.memory_consumption=128'; \
      echo 'opcache.interned_strings_buffer=8'; \
      echo 'opcache.max_accelerated_files=4000'; \
      echo 'opcache.revalidate_freq=2'; \
      echo 'opcache.fast_shutdown=1'; \
      echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini