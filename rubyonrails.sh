sitename=$1
mysqlpassword=$2

vagranthome="/home/vagrant"
rubyonrails="$vagranthome/.rbenv/versions/2.4.0"

sudo cp -R /var/www/public/ssh/rubyonrails.sh $vagranthome

echo "Login as a superuser"
sudo su

if [ -d "$rubyonrails" ]
then
  echo "Ruby On Rails already installed."
else
  echo "Starting to install Ruby On Rails."
  cd $vagranthome
  rm -rf $vagranthome/.rbenv
  echo "Rbenv has been removed."
  git clone https://github.com/rbenv/rbenv.git $vagranthome/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $vagranthome/.bashrc
  echo 'eval "$(rbenv init -)"' >> $vagranthome/.bashrc
  #exec $SHELL
  source $vagranthome/.bashrc
  echo "Rbenv has been reinstalled."
  git clone https://github.com/rbenv/ruby-build.git $vagranthome/.rbenv/plugins/ruby-build
  echo 'export PATH="$vagranthome/.rbenv/plugins/ruby-build/bin:$PATH"' >> $vagranthome/.bashrc
  #exec $SHELL
  source $vagranthome/.bashrc
  echo 'Changing permissions of /.rbenv'
  chmod -R 777 $vagranthome/.rbenv
  chmod -R 777 /var/lib/dpkg/lock
  chmod -R 777 /var/cache/apt
  sudo -H -u vagrant bash -i -c 'rbenv install 2.4.0'
  echo "Set Ruby as global"
  sudo -H -u vagrant bash -i -c 'rbenv global 2.4.0'
  echo "Rehash Ruby"
  sudo -H -u vagrant bash -i -c 'rbenv rehash'
  sudo -H -u vagrant bash -i -c 'gem install bundler'
  sudo -H -u vagrant bash -i -c 'rbenv rehash'
  sudo -H -u vagrant bash -i -c 'curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -'
  sudo -H -u vagrant bash -i -c 'apt-get install -y nodejs'
  sudo -H -u vagrant bash -i -c 'gem install rails -v 5.0.1'
  sudo -H -u vagrant bash -i -c 'rails -v'
  sudo -H -u vagrant bash -i -c 'rbenv rehash'
  sudo -H -u vagrant bash -i -c 'apt-get install -y libmysqlclient18 mysql-common libmysqlclient-dev libpq-dev'
  sudo -H -u vagrant bash -i -c 'rbenv rehash'
  chmod -R 755 $vagranthome/.rbenv
  chmod -R 755 /var/lib/dpkg/lock
  chmod -R 755 /var/cache/apt
fi
echo "Completed."
