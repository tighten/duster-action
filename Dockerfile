FROM php:8.2-alpine

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php
RUN ./composer.phar require tightenco/duster ^2.0 --no-progress --dev
ENV PATH="/vendor/bin:${PATH}"

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
