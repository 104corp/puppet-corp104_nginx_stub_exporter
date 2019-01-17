# Class: corp104_nginx_stub_exporter::service
#
# This module manages nginx_stub_exporter service
#
class corp104_nginx_stub_exporter::service (
  String    $user              = $corp104_nginx_stub_exporter::user,
  String    $group             = $corp104_nginx_stub_exporter::group,
  Boolean   $manage_user       = true,
  Array     $extra_groups      = [],
  Boolean   $manage_group      = true,
  String    $bin_dir           = $corp104_nginx_stub_exporter::bin_dir,
  String    $init_style        = $corp104_nginx_stub_exporter::init_style,
  String    $service_name      = $corp104_nginx_stub_exporter::service_name,
  String    $service_ensure    = 'running',
  Boolean   $service_enable    = true,
  Boolean   $manage_service    = true,
  Boolean   $restart_on_change = true,
  String    $extra_options     = '',
  String    $nginx_scrape_uri  = $corp104_nginx_stub_exporter::nginx_scrape_uri,
  Hash[String,Scalar] $extra_env_vars = $corp104_nginx_stub_exporter::extra_env_vars,
) inherits corp104_nginx_stub_exporter {

  $notify_service = $restart_on_change ? {
    true    => Service[$service_name],
    default => undef,
  }

  $options = "-nginx.scrape-uri=\"${nginx_scrape_uri}\" ${extra_options}"

  # Default Environment variables 
  $env_vars = {}
  
  $real_env_vars = merge($env_vars, $extra_env_vars)

  corp104_nginx_stub_exporter::daemon { $service_name:
    notify_service     => $notify_service,
    user               => $user,
    group              => $group,
    manage_user        => $manage_user,
    extra_groups       => $extra_groups,
    manage_group       => $manage_group,
    bin_dir            => $bin_dir,
    init_style         => $init_style,
    service_ensure     => $service_ensure,
    service_enable     => $service_enable,
    manage_service     => $manage_service,
    options            => $options,
    env_vars           => $real_env_vars,
  }
}
