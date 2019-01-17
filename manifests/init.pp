# Class: corp104_nginx_stub_exporter
# ===========================
#
# Full description of class corp104_nginx_stub_exporter here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'corp104_nginx_stub_exporter':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class corp104_nginx_stub_exporter (
  String    $package_name,
  String    $version,
  String    $package_ensure,
  String    $install_method,
  String    $download_url,
  String    $download_extension,
  Optional[String] $http_proxy,
  String    $user,
  String    $group,
  Boolean   $manage_user,
  Array     $extra_groups,
  Boolean   $manage_group,
  String    $bin_dir,
  String    $init_style,
  String    $service_name,
  String    $service_ensure,
  Boolean   $service_enable,
  Boolean   $manage_service,
  Boolean   $restart_on_change,
  Optional[String] $extra_options,
  String    $nginx_scrape_uri,
  String    $env_file_path,
  Hash[String,Scalar] $extra_env_vars = {},
) {
  contain corp104_nginx_stub_exporter::install
  contain corp104_nginx_stub_exporter::service

  Class['::corp104_nginx_stub_exporter::install']
  ~> Class['::corp104_nginx_stub_exporter::service']
}
