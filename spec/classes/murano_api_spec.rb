require 'spec_helper'

describe 'murano::api' do

  shared_examples_for 'murano-api' do
    it { is_expected.to contain_class('murano::api') }
  end

  context 'on a RedHat osfamily' do
    let :facts do
      {
          :osfamily               => 'RedHat',
          :operatingsystemrelease => '7.0',
          :concat_basedir         => '/var/lib/puppet/concat'
      }
    end

    it_configures 'murano-api'

    it_behaves_like 'generic murano service', {
        :name         => 'murano-api',
        :package_name => 'openstack-murano-api',
        :service_name => 'murano-api'
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

    it_configures 'murano-api'

    it_behaves_like 'generic murano service', {
        :name         => 'murano-api',
        :package_name => 'murano-api',
        :service_name => 'murano-api'
      }
  end
end
