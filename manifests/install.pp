class corp104_nginx_stub_exporter::install inherits corp104_nginx_stub_exporter {

  if $corp104_nginx_stub_exporter::remote_source {
    file { $corp104_nginx_stub_exporter::install_path:
      ensure => directory,
      mode   => '0755',
    }
    -> archive { "${corp104_nginx_stub_exporter::install_path}/nginx-stub-exporter":
      ensure          => present,
      source          => $corp104_nginx_stub_exporter::remote_source,
      checksum_verify => false,
    }
    -> file { "${corp104_nginx_stub_exporter::install_path}/nginx-stub-exporter":
      ensure => file,
      mode   => '0755',
    }
  }
  else {

  }




}
