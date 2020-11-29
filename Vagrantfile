$script_provision = <<-SCRIPT
  echo "Provisioning NGINX"
  apt-get -qq update && apt-get -qq install -y nginx > nginx_install.log
  echo "Provisioning MYSQL"
  apt-get -qq install -y mysql-server-5.7 > mysql_install.log
  echo "Configuring remote access"
  cat /configs/mysql/mysqld.cnf > /etc/mysql/mysql.conf.d/mysqld.cnf
  echo "Restarting MYSQL"
  service mysql restart
  echo "Database created succesffully"
SCRIPT

$script_create_user = <<-SCRIPT
  echo "Creating user on mysql"
  mysql -e "CREATE USER 'softcube'@'%' IDENTIFIED BY 'Brasil@77!';"
  mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'softcube'@'%';"
  mysql -e "FLUSH PRIVILEGES;"
  echo "User created"
SCRIPT

$script_create_database = <<-SCRIPT
  echo "Creating database 'store'"
  mysql -e "CREATE DATABASE store;"
  echo "Database created succesffully"
SCRIPT

$script_java = <<-SCRIPT
  echo "Installing Java"
  apt-get update > update.log && apt-get install openjdk-8-jdk -y > java_install.log
  echo "Java installed"
SCRIPT

$script_wildfly = <<-SCRIPT
  echo "Downloading Wildfly"
  wget https://download.jboss.org/wildfly/17.0.1.Final/wildfly-17.0.1.Final.tar.gz > wildfly_install.log
  echo "Wildfly downloaded"
  echo "Extracting Wildfly"
  tar -xzf wildfly-17.0.1.Final.tar.gz
  echo "Wildfly extracted"

  echo "Configuring Wildfly"
  cat /configs/wildfly/standalone.xml > /home/vagrant/wildfly-17.0.1.Final/standalone/configuration/standalone.xml
  echo "Wildfly configured"
  echo "Starting..."
  ./wildfly-17.0.1.Final/bin/standalone.sh >> wildfly_start.log &
  echo "Started"
SCRIPT

$script_puppet = <<-SCRIPT
  echo "Updating and Installing Puppet"
  apt-get update >> puppet_install.log && apt-get install puppet -y >> puppet_install.log
  echo "Done"
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.define "mysql" do |mysql|
    mysql.vm.network "forwarded_port", guest: 3306, host: 3307
    mysql.vm.network "public_network", ip: "192.168.0.230"

    mysql.vm.synced_folder ".", "/vagrant", disabled: true
    mysql.vm.synced_folder "./configs", "/configs"
    mysql.vm.synced_folder "./configs/mysql", "/configs/mysql"

    mysql.vm.provision "shell", inline: "cat /configs/id_bionic_rafael.pub >> .ssh/authorized_keys"

    mysql.vm.provision "shell", inline: $script_provision
    mysql.vm.provision "shell", inline: $script_create_user
    mysql.vm.provision "shell", inline: $script_create_database
  end

  config.vm.define "wildfly" do |wildfly|
    wildfly.vm.network "forwarded_port", guest: 9990, host: 9990
    wildfly.vm.network "public_network", ip: "192.168.0.231"

    wildfly.vm.synced_folder ".", "/vagrant", disabled: true
    wildfly.vm.synced_folder "./configs", "/configs"
    wildfly.vm.synced_folder "./configs/wildfly", "/configs/wildfly"
    wildfly.vm.synced_folder "./configs/wildfly/puppet/manifest", "/configs/wildfly/puppet/manifest"

    wildfly.vm.provision "shell", inline: "cat /configs/id_bionic_rafael.pub >> .ssh/authorized_keys"

    wildfly.vm.provision "shell", inline: $script_puppet
    wildfly.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "./configs/wildfly/puppet/manifest"
      puppet.manifest_file = "puppet_wildfly.pp"
    end
  end
end
