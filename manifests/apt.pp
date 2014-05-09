class project::apt {

    exec { "apt-update":
        command => "apt-get update"
    }

    # Ensure apt-get update has been run before installing any packages
    Exec["apt-update"] -> Package <| |>
}