define solr::server ($source_dir,
                     $home_dir       = '/opt/solr',
                     $log_dir        = '/var/log/solr',
                     $user           = 'solr',
                     $group          = 'solr',
                     $enable_service = true,
                     $ensure_service = undef,
                     $java_options   = {}
) {

  file { "${home_dir}":
    ensure    => directory,
    recurse   => true,
    source    => $source_dir,
    owner     => $user,
    group     => $group,
  }

  file { "${log_dir}":
    ensure    => directory,
    owner     => $user,
    group     => $group,
    require   => File[$home_dir],
  }

  #Configure logging
  file { "${home_dir}/etc/jetty.xml":
    ensure    => present,
    content   => template('solr/etc/jetty.xml.erb'),
    owner     => $user,
    group     => $group,
    mode      => 0644,
    require   => File[$home_dir],
  }

  #Creates init.d script to start jetty
  file { '/etc/init.d/solr':
    ensure    => present,
    source    => 'puppet:///modules/solr/jetty.sh',
    owner     => 'root',
    group     => 'root',
    mode      => 0755,
    require   => File[$home_dir],
  }

  #Creates script to load environment variables
  file { '/etc/default/jetty':
    ensure    => present,
    content   => template('solr/etc/jetty.erb'),
    owner     => 'root',
    group     => 'root',
    mode      => 0644,
    require   => File[$home_dir],
  }

  service { 'solr':
    enable    => $enable_service,
    ensure    => $ensure_service,
    hasstatus => false,
    status    => "ps aux | grep solr.solr.home=${home_dir}/solr | grep -v grep",
    require   => [File['/etc/default/jetty'], File['/etc/init.d/solr'],
  }

}
