class project {

    include augeas
    include project::apt

    file {
      "/home/vagrant/.bashrc":
      ensure  => present,
      source  => "puppet:///modules/project/.bashrc",
      owner   => 'vagrant',
      group   => 'vagrant',
      mode    => '0644'
    }

    exec { "line-endings-bashrc":
        command => "vi +':w ++ff=unix' +':q' /home/vagrant/.bashrc",
        cwd     => '/',
        path    => ['/usr/bin'],
        require => File['/home/vagrant/.bashrc']
    }
}