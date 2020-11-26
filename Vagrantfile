$script_provision = <<-SCRIPT
  echo "Provisioning NGINX"
  apt-get -qq update && apt-get -qq install -y nginx
  echo "Provisioning MYSQL"
  apt-get -qq install -y mysql-server-5.7
  echo "Configuring remote access"
  cat /configs/mysqld.cnf > /etc/mysql/mysql.conf.d/mysqld.cnf
  echo "Restarting MYSQL"
  service mysql restart
SCRIPT

$script_create_user = <<-SCRIPT
  echo Creating user on mysql
  mysql -e "CREATE USER 'softcube'@'%' IDENTIFIED BY 'Brasil@77!';"
  mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'softcube'@'%';"
  mysql -e "FLUSH PRIVILEGES;"
  echo User created
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.network "forwarded_port", guest: 80, host: 8090
  config.vm.network "forwarded_port", guest: 3306, host: 3307
  config.vm.network "public_network", ip: "192.168.0.170"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./configs", "/configs"

  config.vm.provision "shell", inline: "cat /configs/id_bionic_rafael.pub >> .ssh/authorized_keys"

  config.vm.provision "shell", inline: $script_provision
  config.vm.provision "shell", inline: $script_create_user

end
