require 'spec_helper_acceptance'

describe 'install corp104_nginx_stub_exporter' do
  context 'default parameters' do
    it 'should install package' do
      pp = "class { 'corp104_nginx_stub_exporter': }"

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'change node version' do
    it 'should install package' do
      pp = <<-EOS
        class { 'corp104_nginx_stub_exporter':
          python_version => '3.7.0'
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
