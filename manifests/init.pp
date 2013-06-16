class project {

    include augeas

    include project::apt
    include project::composer
    include project::web
    include project::php5
    include project::pear
    include project::phing
    include project::sql

    if ($project-lamp) {
        include project::varnish
    }

    if ($project-jenkins) {
        include project::jenkins
    }
}