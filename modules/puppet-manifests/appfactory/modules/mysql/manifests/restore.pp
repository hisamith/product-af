class mysql::restore($databases, $dump_dir = '/mnt/backups/mysqldump'){

  $password = "root"
  service{ "mysql":
    ensure  => "running",
    enable  => true
  }

  restore_database{
    $databases:
    dump_dir => $dump_dir
  }

  define restore_database($dump_dir) {
    $root_user = "root"
    $root_password = "root"

    $sql_command = "  < ${dump_dir}/${title}.sql;"

    exec { "backup-${title}-db":
      path    => ['/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'],
      onlyif => "ls  $dump_dir/$title.sql ",
      command => "/usr/bin/mysql -u$root_user -p$root_password $sql_command",
    }
  }
}