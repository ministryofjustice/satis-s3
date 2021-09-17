FROM php:7-cli

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -yq --no-install-recommends python-setuptools python3-pip git zlib1g-dev libzip-dev openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && pip install awscli

RUN docker-php-ext-install zip

RUN echo "date.timezone = UTC" >> /usr/local/etc/php/php.ini \
	&& curl -sS https://getcomposer.org/installer | php \
	&& php composer.phar create-project composer/satis --stability=dev \
	&& ln /satis/bin/satis /usr/local/bin

RUN mkdir ~/.ssh \
	&& ssh-keyscan -H bitbucket.org >> /root/.ssh/known_hosts \
	&& ssh-keyscan -H github.com >> /root/.ssh/known_hosts

# Update composer and satis to the latest versions
RUN php composer.phar self-update && \
    rm -rf /satis && \
    php composer.phar create-project composer/satis --stability=dev --no-interaction

# Overwrite existing run.sh with our own version.
# Our version additionally configures GitHub auth for composer to avoid API usage limits,
# and uses different command line options for syncing files to S3.
ADD run.sh /run.sh
