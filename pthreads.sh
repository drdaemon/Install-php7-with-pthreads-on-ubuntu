#!/bin/sh

# http://stackoverflow.com/questions/34969325/how-to-install-php7-zts-pthreads-on-ubuntu-14-04
# https://github.com/ibrunotome/Install-php7-with-pthreads-on-ubuntu

apt-get update -y
apt-get install -y build-essential libcurl4-openssl-dev libsqlite3-dev sqlite3 mysql-server libmysqlclient-dev libreadline-dev libzip-dev libxslt1-dev libicu-dev libmcrypt-dev libmhash-dev libpcre3-dev libjpeg-dev libpng12-dev libfreetype6-dev libbz2-dev libxpm-dev
apt-get -y build-dep php7.0

wget http://cl1.php.net/get/php-7.0.8.tar.gz/from/this/mirror -O php-7.0.8.tar.gz

tar zxvf php-7.0.8.tar.gz

rm -rf ext/pthreads/

wget http://pecl.php.net/get/pthreads-3.1.6.tgz -O pthreads-3.1.6.tgz
tar zxvf pthreads-3.1.6.tgz

cp -a pthreads-3.1.6/. php-7.0.8/ext/pthreads/

wget http://pecl.php.net/get/yaml-2.0.0.tgz -O yaml-2.0.0.tgz
tar zxvf yaml-2.0.0.tgz

cp -a yaml-2.0.0/. php-7.0.8/ext/yaml/

cd php-7.0.8

rm -rf aclocal.m4
rm -rf autom4te.cache/
./buildconf --force
make distclean

./configure --disable-fileinfo --enable-maintainer-zts --enable-pthreads --prefix=/etc/php7 \
    --with-config-file-path=/etc/php7/cli --with-curl --enable-cli \
    --with-config-file-scan-dir=/etc/php7/etc \
    --disable-cgi \
    --enable-debug \
    --enable-mbstring \
    --enable-mbregex \
    --enable-phar \
    --enable-posix \
    --enable-soap \
    --enable-sockets \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-zip \
    --enable-inline-optimization \
    --enable-intl \
    --with-icu-dir=/usr \
    --with-gd \
    --with-jpeg-dir=/usr \
    --with-png-dir=shared,/usr \
    --with-xpm-dir=/usr \
    --with-freetype-dir=/usr \
    --with-bz2=/usr \
    --with-gettext \
    --with-iconv-dir=/usr \
    --with-mcrypt=/usr \
    --with-mhash \
    --with-zlib-dir=/usr \
    --with-regex=php \
    --with-pcre-regex \
    --with-openssl \
    --with-openssl-dir=/usr/bin \
    --with-mysql-sock=/var/run/mysqld/mysqld.sock \
    --with-mysqli=mysqlnd \
    --with-sqlite3 \
    --with-pdo-mysql=mysqlnd \
    --with-pdo-sqlite \
    --config-cache \
    --localstatedir=/var \
    --with-layout=GNU \
    --disable-rpath

make clear 

make

make install
#cp php.ini-development /etc/php7/cli/php.ini
#cp php.ini-development /etc/php7/cli/php-cli.ini

cp -r php.ini-production /etc/php7/cli/php.ini
cp php.ini-production /etc/php7/cli/php-cli.ini

cd ext/yaml

/etc/php7/bin/phpize

./configure --prefix='/etc/php7' --with-libdir='/lib/x86_64-linux-gnu' --with-php-config='/etc/php7/bin/php-config'

make

make install

cd ../../

echo "extension=yaml.so" >> /etc/php7/cli/php-cli.ini

cd ..

rm php-7.0.8.tar.gz
rm -rf php-7.0.8
rm -rf pthreads-3.1.6
rm pthreads-3.1.6.tgz
