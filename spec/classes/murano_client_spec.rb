require 'spec_helper'

describe 'murano::client' do

  shared_examples_for 'murano client' do

    it { is_expected.to contain_class('murano::deps') }
    it { is_expected.to contain_class('murano::params') }

    it 'installs murano client package' do
      is_expected.to contain_package('python-muranoclient').with(
        :ensure => 'present',
        :name   => platform_params[:pythonclient_package_name],
        :tag    => ['openstack', 'murano-packages']
      )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let :platform_params do
        case facts[:osfamily]
        when 'Debian'
          { :pythonclient_package_name => 'python3-muranoclient' }
        when 'RedHat'
          { :pythonclient_package_name => 'python3-muranoclient' }
        end
      end

      it_behaves_like 'murano client'
    end
  end

end
