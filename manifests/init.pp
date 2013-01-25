define solr::server ($source_dir,
                     $home_dir      = '/opt/solr',
                     $log_dir       = '/var/log/solr',
                     $user          = 'solr',
                     $group         = 'solr',
                     $java_options  = {}
) {

  file { '/opt/solr':
    ensure    => directory,
    recurse   => true,
    source    => '/tmp/solr',
    owner     => $user,
    group     => $group,
    require   => Exec['uncompress_solr'],
  }

  file { '/var/log/solr':
    ensure    => directory,
    owner     => $user,
    group     => $group,
    require   => File['/opt/solr'],
  }

  #Configure logging
  file { '/opt/solr/etc/jetty.xml':
    ensure    => present,
    content   => template('solr/etc/jetty.xml.erb'),
    owner     => $user,
    group     => $group,
    mode      => 0644,
    require   => File['/opt/solr'],
  }

  #Creates init.d script to start jetty
  file { '/etc/init.d/solr':
    ensure    => present,
    source    => 'puppet:///modules/solr/jetty.sh',
    owner     => 'root',
    group     => 'root',
    mode      => 0755,
    require   => File['/opt/solr'],
  }

  #Creates script to load environment variables
  file { '/etc/default/jetty':
    ensure    => present,
    content   => template('solr/etc/jetty.erb'),
    owner     => 'root',
    group     => 'root',
    mode      => 0644,
    require   => File['/opt/solr'],
  }

  service { 'solr':
    enable    => true,
    ensure    => running,
    require   => File['/etc/default/jetty'],
  }

}
