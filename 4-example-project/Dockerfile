# Create args for PHP extensions and PECL packages we need to install.
# This makes it easier if we want to install packages,
# as we have to install them in multiple places.
# This helps keep ou Dockerfiles DRY -> https://bit.ly/dry-code
# You can see a list of required extensions for Laravel here: https://laravel.com/docs/8.x/deployment#server-requirements
ARG PHP_EXTS="bcmath ctype fileinfo mbstring pdo pdo_mysql dom pcntl gd zip curl"
ARG PHP_PECL_EXTS="redis"

#     pdo \
#     pdo_mysql \
#     gd \
#     exif \
#     pcntl \
#     bcmath \
#     ctype \
#     curl \
#     iconv \
#     xml \
#     soap \
#     pcntl \
#     mbstring \
#     tokenizer \
#     bz2 \
#     zip \
#     intl

# We need to build the Composer base to reuse packages we've installed
FROM php:8.2.11-fpm  as composer_base

# We need to declare that we want to use the args in this build step
ARG PHP_EXTS
ARG PHP_PECL_EXTS

# Install composer
RUN echo "\e[1;33mInstall COMPOSER\e[0m"
RUN cd /tmp \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN apt-get update

# Install useful tools
RUN apt-get -y install apt-utils nano wget dialog vim

# Install important libraries
RUN echo "\e[1;33mInstall important libraries\e[0m"
RUN apt-get -y install --fix-missing \
    apt-utils \
    build-essential \
    git \
    curl \
    libcurl4 \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libzip-dev \
    zip \
    libbz2-dev \
    locales \
    libmcrypt-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    libpng-dev \
    libfreetype6-dev

RUN docker-php-ext-configure gd --with-freetype

RUN echo "\e[1;33mInstall important docker dependencies\e[0m"
RUN docker-php-ext-install ${PHP_EXTS}

RUN pecl install ${PHP_PECL_EXTS}
RUN docker-php-ext-enable ${PHP_PECL_EXTS}

# First, create the application directory, and some auxilary directories for scripts and such
RUN mkdir -p /opt/apps/laravel-in-kubernetes /opt/apps/laravel-in-kubernetes/bin

# Next, set our working directory
WORKDIR /opt/apps/laravel-in-kubernetes

# Copy in our dependency files.
# We want to leave the rest of the code base out for now,
# so Docker can build a cache of this layer,
# and only rebuild when the dependencies of our application changes.
COPY ./ ./

# Install all the dependencies without running any installation scripts.
# We skip scripts as the code base hasn't been copied in yet and script will likely fail,
# as `php artisan` available yet.
# This also helps us to cache previous runs and layers.
# As long as comoser.json and composer.lock doesn't change the install will be cached.
RUN composer install

# We need an nginx container which can pass requests to our FPM container,
# as well as serve any static content.
FROM nginx:alpine as web_server

# First, create the application directory, and some auxilary directories for scripts and such
RUN mkdir -p /opt/apps/laravel-in-kubernetes

# We need to add our NGINX template to the container for startup,
# and configuration.
COPY ./infra/docker/nginx-default.conf /etc/nginx/conf.d/default.conf

# Copy in ONLY the public directory of our project.
# This is where all the static assets will live, which nginx will serve for us.
COPY --from=composer_base /opt/apps/laravel-in-kubernetes/public /opt/apps/laravel-in-kubernetes/public
