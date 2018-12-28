require 'spec_helper'

describe 'corp104_nginx_stub_exporter', :type => 'class' do
  context 'with defaults for all parameters' do
    let(:facts) do
      { 
        :os => { :family => 'Debian', :name => 'Ubuntu', :release => { :major => '16.04', :full => '16.04' }},
        :lsbdistrelease  => '16.04',
        :lsbdistid       => 'Ubuntu',
        :osfamily        => 'Debian',
        :lsbdistcodename => 'xenial',
      }
    end
    it do
      should contain_class('corp104_nginx_stub_exporter')
      should contain_class('corp104_nginx_stub_exporter::install')
    end

    it do
      should compile.with_all_deps
    end

  end
end
