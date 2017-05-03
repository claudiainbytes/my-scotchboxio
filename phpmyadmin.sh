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
  echo "So let's restart apache..."
  sudo apt-get install php-mbstring
  sudo service apache2 restart
else
  echo "scotchbox.local.conf not found. No cleanup needed."
fi

phpmyadmin="/etc/phpmyadmin"
if [ -d "$phpmyadmin" ]
then
  echo "PHPMyAdmin already installed."
else
  echo "Installing PHPMyAdmin..."
  mysql -uroot -proot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$mysqlpassword'); FLUSH PRIVILEGES;"
  sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
  sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $mysqlpassword"
  sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $mysqlpassword"
  sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $mysqlpassword"
  sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
  sudo apt-get -y install phpmyadmin
  randomBlowfishSecret=`openssl rand -base64 32`;
  cd $phpmyadmin
  sudo sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomBlowfishSecret'|" config.sample.inc.php > config.inc.php
fi

cd

echo "Creating database, if it doesn't already exist"
mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS $sitename;"

echo 'PHPMyAdmin Provisioning complete.'
