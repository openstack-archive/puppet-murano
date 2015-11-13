require 'spec_helper'

describe 'murano::cfapi' do

  shared_examples_for 'murano-cfapi' do
    it { is_expected.to contain_class('murano::cfapi') }
  end

  shared_examples_for 'with default parameters' do
    it { is_expected.to contain_class('murano::params') }
    it { is_expected.to contain_class('murano::policy') }

    it { is_expected.to contain_murano_config('DEFAULT/cfapi_bind_host').with_value('<SERVICE_DEFAULT>') }
    it { is_expected.to contain_murano_config('DEFAULT/cfapi_bind_port').with_value('<SERVICE_DEFAULT>') }
  end

  shared_examples_for 'with parameters override' do
    let :params do {
      :host => '0.0.0.0',
      :port => 8080,
    }
    end

    it { is_expected.to contain_class('murano::params') }
    it { is_expected.to contain_class('murano::policy') }

    it { is_expected.to contain_murano_config('DEFAULT/cfapi_bind_host').with_value('0.0.0.0') }
    it { is_expected.to contain_murano_config('DEFAULT/cfapi_bind_port').with_value(8080) }
  end

  context 'on a RedHat osfamily' do
    let :facts do
      {
          :osfamily               => 'RedHat',
          :operatingsystemrelease => '7.0',
          :concat_basedir         => '/var/lib/puppet/concat'
      }
    end

    it_configures 'murano-cfapi'

    it_behaves_like 'generic murano service', {
        :name         => 'murano-cfapi',
        :package_name => 'openstack-murano-cfapi',
        :service_name => 'murano-cfapi'
      }
  end

  context 'on a Debian osfamily' do
    let :facts do
      {
          :operatingsystemrelease => '7.8',
          :operatingsystem        => 'Debian',
          :osfamily               => 'Debian',
          :concat_basedir         => '/var/lib/puppet/concat'
      }
    end

    it_configures 'murano-cfapi'

    it_behaves_like 'generic murano service', {
        :name         => 'murano-cfapi',
        :package_name => 'murano-cfapi',
        :service_name => 'murano-cfapi'
      }
  end
end
