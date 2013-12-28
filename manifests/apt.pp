class project::apt {
    exec { "apt-update":
        command => "apt-get update"
    }

    # Ensure apt-get update has been run before installing any packages
    Exec["apt-update"] -> Package <| |>

    exec { "adding-dotdeb":
        command => "echo 'deb http://packages.dotdeb.org wheezy all' >> /etc/apt/sources.list && echo 'deb-src http://packages.dotdeb.org wheezy all' >> /etc/apt/sources.list && wget http://www.dotdeb.org/dotdeb.gpg && sudo apt-key add dotdeb.gpg",
        before  => Exec['apt-update']
    }
}