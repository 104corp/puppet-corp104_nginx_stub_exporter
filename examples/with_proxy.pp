class { 'corp104_nginx_stub_exporter':
  http_proxy     => 'http://change.proxy.com:3128',
  python_version => '3.7.0',
}
