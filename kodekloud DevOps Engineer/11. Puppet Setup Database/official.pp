class mysql_database {
  package { 'mariadb-server':
    ensure => installed,
  }

  service { 'mariadb':
    ensure => running,
    enable => true,
  }

  # Create the database
  mysql::db { 'kodekloud_db4':
    user     => 'kodekloud_pop',
    password => 'GyQkFRVNr3',
    host     => 'localhost',
    grant    => ['ALL'],
  }
}

node 'stdb01.stratos.xfusioncorp.com' {
  include mysql_database
}