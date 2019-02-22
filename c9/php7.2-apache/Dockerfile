FROM mcaubrey/cloud9:minimal
RUN apt-get update -y

# ------------------------------------------------------------------------------
# Install Composer and PHP 7.2 and configure Apache
USER root
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install php -y
RUN apt-get install -y apache2-bin libapache2-mod-php libicu-dev libmcrypt-dev libpng-dev libpq-dev libssl-dev libxml2-dev libzip-dev php-bcmath php-bz2 php-cgi php-cli php-common php-curl php-dba php-dev php-enchant php-fpm php-gd php-gmp php-imap php-interbase php-intl php-json php-ldap php-mbstring php-mysql php-odbc php-opcache php-pear php-pgsql php-phpdbg php-pspell php-readline php-recode php-snmp php-soap php-sqlite3 php-sybase php-tidy php-xml php-xmlrpc php-xsl php-zip
USER root

USER root
RUN echo 'AddDefaultCharset utf-8' >> /etc/apache2/apache2.conf
USER root

RUN sudo apt install php-cli php-mbstring -y
WORKDIR /root/
RUN sudo curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

USER root
ADD ./php.ini /etc/php/7.2/apache2/php.ini.newlines
RUN cat /etc/php/7.2/apache2/php.ini.newlines >> /etc/php/7.2/apache2/php.ini \
    && rm -rf /etc/php/7.2/apache2/php.ini.newlines
ADD ./default.conf /etc/apache2/sites-available/000-default.conf


# ------------------------------------------------------------------------------
# Clean up.
RUN rm -rf /var/lib/apt/lists/*