
class githubmirror {

  file { '/root/gitmirror.sh':
    ensure => present,
    mode => 0777,
    source => 'puppet://modules/githubmirror/githubmirror.sh'
  }

  service { 'crond':
    name => 'crond',
    ensure => running,
    enable => true
  }

  cron { "run-gitmirror":
    command => "/root/githubmirror.sh",
    user => root,
    minute => "*/10"
  }

}


class {'githubmirror':}
