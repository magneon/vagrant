exec { 'java8-install':
  command => '/usr/bin/apt-get install openjdk-8-jdk -y > java_install.log',
}

exec { 'wildfly-download':
  command => '/usr/bin/wget https://download.jboss.org/wildfly/17.0.1.Final/wildfly-17.0.1.Final.tar.gz > wildfly_install.log',
  group => 'root',
  user => 'root'
}

exec { 'wildfly-extract':
  command => '/bin/tar -xzf /home/vagrant/wildfly-17.0.1.Final.tar.gz',
  group => 'root',
  user => 'root'
}

exec { 'wildfly-config':
  command => '/bin/cat /configs/wildfly/standalone.xml > /home/vagrant/wildfly-17.0.1.Final/standalone/configuration/standalone.xml'
}

exec { 'wildfly-start':
  command => '/bin/bash /home/vagrant/wildfly-17.0.1.Final/bin/standalone.sh &'
}

exec { 'clean-directory':
  command => '/bin/rm -rf *.tar.gz*'
}
