FROM ubuntu:18.04
RUN apt-get update \
    && apt-get install sudo curl wget gnupg -y
RUN useradd -ms /bin/bash student
RUN usermod -a -G sudo student
RUN echo 'student ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN apt-get install -y locales \
    && locale-gen en_US.UTF-8
USER student

# Install dependencies
RUN curl -sL https://deb.nodesource.com/setup_11.x | sudo bash - \
    && sudo apt-get install nodejs -y
RUN sudo apt-get install -y --no-install-recommends \
    build-essential git dos2unix pylint virtualenv python3-dev python3-pip openssh-server \
 && sudo mkdir /fallback \
 && sudo mkdir /fallback/workspace \
 && sudo mkdir /cloud9


# Get cloud9 source and install
RUN sudo chown -R student /cloud9
WORKDIR /cloud9
RUN git clone https://github.com/c9/core.git .
RUN scripts/install-sdk.sh 
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' configs/standalone.js \
 && sed -i -e 's_message: "-d all -e E -e F",_message: "-d all -e E,F,W",_g' plugins/c9.ide.language.python/python.js


# Add fallback workspace
VOLUME /cloud9/workspace


# Set default workspace dir
ENV WORKSPACE /cloud9/workspace

# ------------------------------------------------------------------------------
# Set up CodeIntel

RUN sudo apt install python-pip -y
RUN sudo pip install -U pip
RUN sudo pip install -U virtualenv
RUN virtualenv --python=python2 /root/.c9/python2
RUN . /root/.c9/python2/bin/activate
RUN sudo apt-get update
RUN sudo apt-get install python-dev -y
RUN mkdir /tmp/codeintel
RUN pip download -d /tmp/codeintel codeintel==0.9.3
WORKDIR /tmp/codeintel
RUN tar xf CodeIntel-0.9.3.tar.gz
RUN mv CodeIntel-0.9.3/SilverCity CodeIntel-0.9.3/silvercity
RUN tar czf CodeIntel-0.9.3.tar.gz CodeIntel-0.9.3
RUN sudo pip install -U --no-index --find-links=/tmp/codeintel codeintel

WORKDIR /cloud9

# Custom Cloud9 settings
COPY ./user.settings /root/.c9/user.settings
RUN sudo chmod -R 777 /root/.c9/user.settings

# Custom themes for Cloud9
RUN rm -rf /cloud9/plugins/c9.ide.server/views/flat-load-screen.html
COPY ./flat-load-screen.html /cloud9/plugins/c9.ide.server/views/flat-load-screen.html
RUN rm -rf /cloud9/plugins/c9.vfs.standalone/www/ide.html
COPY ./ide.html /cloud9/plugins/c9.vfs.standalone/www/ide.html
RUN sudo rm -rf /cloud9/plugins/c9.ide.theme.jett/less/overrides.less
COPY overrides.less /cloud9/plugins/c9.ide.theme.jett/less/overrides.less
RUN echo 'div[title="John Doe"] {display: none;}' >> /cloud9/plugins/c9.ide.layout.classic/loading.css
RUN echo 'div[title="John Doe"] {display: none;}' >> /cloud9/plugins/c9.ide.layout.classic/loading-flat.css


# ------------------------------------------------------------------------------
# Install Apache, Composer and PHP 7.2
USER root
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install php -y
RUN apt-get install -y apache2-bin elinks git libapache2-mod-php libicu-dev libmcrypt-dev libpng-dev libpq-dev libssl-dev libxml2-dev libzip-dev php-bcmath php-bz2 php-cgi php-cli php-common php-curl php-dba php-dev php-enchant php-fpm php-gd php-gmp php-imap php-interbase php-intl php-json php-ldap php-mbstring php-mysql php-odbc php-opcache php-pear php-pgsql php-phpdbg php-pspell php-readline php-recode php-snmp php-soap php-sqlite3 php-sybase php-tidy php-xml php-xmlrpc php-xsl php-zip unzip vim zip
USER root

USER root
RUN apt-get install apache2 -y
USER root

USER root
RUN echo 'AddDefaultCharset utf-8' >> /etc/apache2/apache2.conf
USER root

RUN sudo apt install curl php-cli php-mbstring git unzip -y
WORKDIR /root/
RUN sudo curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

USER root
ADD ./php.ini /etc/php/7.2/apache2/php.ini.newlines
RUN cat /etc/php/7.2/apache2/php.ini.newlines >> /etc/php/7.2/apache2/php.ini \
    && rm -rf /etc/php/7.2/apache2/php.ini.newlines
ADD ./default.conf /etc/apache2/sites-available/000-default.conf


# ------------------------------------------------------------------------------
# Expose ports and add entrypoint.
ADD start.sh /php7.1.2-apache-student/start.sh
RUN sudo dos2unix /start.sh
RUN sudo chmod 777 /start.sh
RUN sudo chmod +x /start.sh
RUN sudo echo 'export PATH=$PATH:/usr/local/bin:~/.composer/vendor/bin:/cloud9/bin' >> /root/.bashrc
EXPOSE 8080 22 443 3306 5432
ENTRYPOINT ["/start.sh"]


# Clean up.
RUN rm -rf /var/lib/apt/lists/*

USER student