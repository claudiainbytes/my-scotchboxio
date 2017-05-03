sitename=$1
mysqlpassword=$2
vagranthome="/home/vagrant"

sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales

scotchbox="/etc/apache2/sites-enabled/scotchbox.local.conf"
if [ -f "$scotchbox" ]
then
  echo "Disabling scotchbox.local.conf. Will probably tell you to restart Apache..."
  #sudo a2dissite scotchbox.local.conf
  echo "Updating to PHP 7..."
  sudo apt-get update
  sudo add-apt-repository ppa:ondrej/php
  sudo apt-get install -y php7.0
  sudo apt-get update
  sudo apt-get install -y php7.0-fpm php7.0-mysql php-curl php7.0-mbstring mcrypt php7.0-mcrypt libapache2-mod-php7.0
  sudo a2dismod php5
  sudo a2enmod php7.0
  echo 'display_startup_errors = On' >> /etc/php/7.0/apache2/php.ini
  echo 'error_reporting = E_ALL' >> /etc/php/7.0/apache2/php.ini
  echo 'display_errors = On' >> /etc/php/7.0/apache2/php.ini
  sudo apachectl restart
  echo "Restarting Apache..."
  cd
else
  echo "scotchbox.local.conf not found. No cleanup needed."
fi

echo 'PHP 7 has been installed.'
