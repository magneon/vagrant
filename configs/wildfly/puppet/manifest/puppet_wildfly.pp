exec { 'apt-get update':
  command => '/usr/bin/apt-get update & > apt-get.log'
}

package { 'openjdk-8-jdk':
  require => Exec['apt-get update'],
  ensure => installed,
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
