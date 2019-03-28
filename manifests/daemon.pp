# Define: corp104_nginx_stub_exporter::daemon
#
# This define managed corp104_nginx_stub_exporter daemons that don't have their own class
#
#  [*notify_service*]
#  The service to notify when something changes in this define
#
#  [*user*]
#  User which runs the service
#
#  [*bin_dir*]
#  Directory where binaries are located
#
#  [*bin_name*]
#  The name of the binary to execute
#
#  [*manage_user*]
#  Whether to create user or rely on external code for that
#
#  [*extra_groups*]
#  Extra groups of which the user should be a part
#
#  [*manage_group*]
#  Whether to create a group for or rely on external code for that
#
#  [*service_ensure*]
#  State ensured for the service (default 'running')
#
#  [*service_enable*]
#  Whether to enable the service from puppet (default true)
#
#  [*manage_service*]
#  Should puppet manage the service? (default true)
#
define corp104_nginx_stub_exporter::daemon (
  $notify_service,
  String $user,
  String $group,
  String $bin_dir                 = $corp104_nginx_stub_exporter::bin_dir,
  String $bin_name                = $name,
  Boolean $manage_user            = true,
  Array $extra_groups             = [],
  Boolean $manage_group           = true,
  String $options                 = '',
  String $init_style              = $corp104_nginx_stub_exporter::init_style,
  String $service_ensure          = 'running',
  Boolean $service_enable         = true,
  Boolean $manage_service         = true,
  Hash[String, Scalar] $env_vars  = {},
  Optional[String] $env_file_path = $corp104_nginx_stub_exporter::env_file_path,
) {

  if $manage_user {
    ensure_resource('user', [ $user ], {
      ensure => 'present',
      system => true,
      groups => $extra_groups,
    })

    if $manage_group {
      Group[$group] -> User[$user]
    }
  }
  if $manage_group {
    ensure_resource('group', [ $group ], {
      ensure => 'present',
      system => true,
    })
  }

  if $init_style {
    case $init_style {
      'upstart' : {
        file { "/etc/init/${name}.conf":
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template("${module_name}/daemon.upstart.erb"),
          notify  => $notify_service,
        }
        file { "/etc/init.d/${name}":
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd' : {
        include 'systemd'
        systemd::unit_file {"${name}.service":
          content => template("${module_name}/daemon.systemd.erb"),
          notify  => $notify_service,
        }
      }
      'sysv','redhat' : {
        file { "/etc/init.d/${name}":
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template("${module_name}/daemon.sysv.erb"),
          notify  => $notify_service,
        }
      }
      'debian' : {
        file { "/etc/init.d/${name}":
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template("${module_name}/daemon.debian.erb"),
          notify  => $notify_service,
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${init_style}")
      }
    }
  }

  if $env_file_path != undef {
    file { "${env_file_path}/${name}":
      mode    => '0644',
      owner   => 'root',
      group   => '0', # Darwin uses wheel
      content => template('corp104_nginx_stub_exporter/daemon.env.erb'),
      notify  => $notify_service,
    }
  }

  $real_provider = $init_style ? {
    'sysv'  => 'redhat',  # all currently used cases for 'sysv' are redhat-compatible
    default => $init_style,
  }

  if $manage_service == true {
    service { $name:
      ensure   => $service_ensure,
      name     => $name,
      enable   => $service_enable,
      provider => $real_provider,
    }
  }
}
