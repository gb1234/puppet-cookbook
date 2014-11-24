#Manage nginx webserver
class nginx {
 package { 'nginx':
  ensure => installed,
  require => Package['apache2.2-common'], 
 }

 package { 'apache2.2-common':
  ensure => absent,
 }
 
 service { 'nginx':
 ensure => running,
 enable => true,
 require => Package['nginx'], 
 }

 file { '/etc/nginx/sites-enabled/default':
 ensure => absent,
} 
 
# $whisper_dirs = [ "/var/www", "/var/www/cat-pictures",
#                ]

# file { $whisper_dirs:
#    ensure => "directory",
# }
  
  file { '/var/www/cat-pictures/index.html':
    content => "I can haz cat pictures?",
 }

 
}
