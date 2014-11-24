import 'website.pp' 
node 'demo' {
         nginx::website { 'adorable-animals':
           site_domain => 'adorable-animals.com',
         }
 file { '/tmp/test':
           content => 'Zaphod Beeblebrox, this is a very large drink',
         } 
 class { 'ntp':
          server => 'us.pool.ntp.org',
        }
 include puppet
 include nginx
 include sudoers
 include ssh
 #using facter to get ipaddress and os details
 file { '/tmp/OSdetails':
   content => inline_template("My address is <%= @ipaddress %>.\n and architecture is <%= @architecture %>.\n"),
  }
 
 $site_name = 'cat-pictures'
 $site_domain = 'cat-pictures.com'
 file { '/etc/nginx/sites-enabled/cat-pictures.conf':
           content => template('nginx/vhost.conf.erb'),
           notify  => Service['nginx'],
         }
 
 
 file { '/var/www/cat-pictures':
  ensure => directory,
  }
 
 file { '/var/www/cat-pictures/img':
  source => 'puppet:///modules/cat-pictures/img',
  recurse => true,
  require => File['/var/www/cat-pictures'],
 }
  
 cron { 'Back up cat-pictures':
  command => '/usr/bin/rsync -az /var/www/cat-pictures/ /cat-pictures-backup/',
  hour => '04',
  minute => '00',
   }
 cron { 'Git pull updates':
  command => '/usr/bin/cd /home/vagrant/puppet && /usr/bin/git pull',
  hour => '*/6',  
  minute => '00',
  }
 
exec { 'Run my arbitrary command':
   command => 'echo I ran this command on `date` > /tmp/command.output.txt',
   path => ['/bin','/usr/bin'],
   } 
 user { 'art':
    ensure => present,
    comment => 'ART Vandlay',
   home => '/home/art',
   managehome => true,
   }
 ssh_authorized_key { 'art_ssh':
  user => 'art',
  type => 'rsa',
  key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDPfS8p6szm+17/FXJcgJJknhQS1eVBMAHrACPUVbaFjC5pw774eeUWd1jjaYCrSxp5RLt82NtXTFBH1tMhKGADsJUsE1slv4ououwGOgGyCyf48c1betCgcwr57t7qHXgl2BO/mMtzt5HxqjTiqV9/t2QzIq4TnLCSxtzYrLT+7cws6lV53HZ91tgkQhSrXJLFhjeO4xBULdTnYD2TwPbonnhj2vSYj6mrMFh30Fj+oQBwzIeANdJ6xfvZwneUIdvPi7xZPV6QqXf2Sq/6Do2sWaqQxOC4yggr1f+G72hU2DPiNNH8v5lMp1RIDrzJRhYN6tl+/jPV1ePAG182UtdN',
  }
}

node 'vagrant-ubuntu-trusty-64' {
  include nginx
}

