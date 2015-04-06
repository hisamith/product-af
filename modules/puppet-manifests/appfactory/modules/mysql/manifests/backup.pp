class mysql::backup($databases, $dump_dir = '/mnt/backups/mysqldump'){

  $password = "root"
  service{ "mysql":
    ensure  => "running",
    enable  => true
  }

  exec {
    "create_dirs_for_${dump_dir}":
      path    => ['/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'],
      command => "mkdir -p ${dump_dir}";
  }

  backup_database{
    $databases:
      dump_dir => $dump_dir,
      require => Exec["create_dirs_for_${dump_dir}"];
  }

  define backup_database($dump_dir) {
    $root_user = "root"
    $root_password = "root"


    $sql_command = " --add-drop-database --database ${title} > ${dump_dir}/${title}.sql;"

    exec { "backup_db_${title}_to_${dump_dir}/${title}.sql":
      onlyif => "/usr/bin/mysql -u$root_user -p$root_password $title",
      command => "/usr/bin/mysqldump -u$root_user -p$root_password $sql_command",
    }
  }
}