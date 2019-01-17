# Class: corp104_nginx_stub_exporter::install
#
# This module manages nginx_stub_exporter install
#
class corp104_nginx_stub_exporter::install (
  String    $package_name      = $corp104_nginx_stub_exporter::package_name,
  String    $version           = $corp104_nginx_stub_exporter::version,
  String    $package_ensure    = 'installed',
  String    $install_method    = 'url',
  String    $download_url      = $corp104_nginx_stub_exporter::download_url,
  String    $download_extension = 'tar.gz',
  String    $bin_dir           = $corp104_nginx_stub_exporter::bin_dir,
  String    $service_name      = $corp104_nginx_stub_exporter::service_name,
  String    $http_proxy        = $corp104_nginx_stub_exporter::http_proxy,
) inherits corp104_nginx_stub_exporter {

  $proxy_server = empty($http_proxy) ? {
    true    => undef,
    default => $http_proxy,
  }

  $install_dir = "/opt/${package_name}-${version}.linux-${facts['architecture']}"

  case $install_method {
    'url': {
      file { $install_dir:
        ensure => 'directory',
        owner  => 'root',
        group  => 0, # 0 instead of root because OS X uses "wheel".
        mode   => '0555',
      }
      -> archive { "/tmp/${package_name}-${version}.${download_extension}":
        ensure          => present,
        source          => $download_url,
        creates         => "${install_dir}/${package_name}",
        extract         => true,
        extract_path    => "${install_dir}",
        proxy_server    => $proxy_server,
        checksum_verify => false,
        cleanup         => true,
      }
      -> file {
        "/opt/${package_name}-${version}.linux-${facts['architecture']}/${package_name}":
          owner => 'root',
          group => 0, # 0 instead of root because OS X uses "wheel".
          mode  => '0555';
        "${bin_dir}/${service_name}":
          ensure => link,
          notify => Service[$service_name],
          target => "/opt/${package_name}-${version}.linux-${facts['architecture']}/${package_name}",
      }
    }
    'package': {
      package { $package_name:
        ensure => $package_ensure,
      }
    }
    default: {
      fail("The provided install method ${install_method} is invalid")
    }
  }
}
