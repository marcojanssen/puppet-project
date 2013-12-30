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
}