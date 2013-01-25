This puppet module installs a Solr server. This module has been tested with Solr version 4.0


#Install a Solr server
		solr::server { 'my_server':
		  source_dir    => '/tmp/solr',
		  home_dir      => '/opt/solr',
		  log_dir       => '/var/log/solr',
		  user          => 'vagrant',
		  group         => 'vagrant',
		  java_options  => {'Setting Xmx' => '-Xmx64m'},
		}

Parameters list:
  source_dir: Directory from where to get source files
  home_dir: Home directory of the Solr server
  log_dir: Solr Log directory
  user: system user that will own Solr home and log directory, and will run solr.
  group: system group that will own Solr home and log directory.
  java_options: list of java options to be passed as params to jetty server.
  
