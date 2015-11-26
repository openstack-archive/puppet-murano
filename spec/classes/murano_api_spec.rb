require 'spec_helper'

describe 'murano::api' do

  shared_examples_for 'murano-api' do
    it { is_expected.to contain_class('murano::api') }

    context 'with default params' do
      it { is_expected.to contain_murano_config('DEFAULT/bind_host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('DEFAULT/bind_port').with_value('<SERVICE DEFAULT>') }
    end

    context 'with passed params' do
      let :params do {
         :host => 'localhost',
         :port => '1111',
      } end
      it { is_expected.to contain_murano_config('DEFAULT/bind_host').with_value('localhost') }
      it { is_expected.to contain_murano_config('DEFAULT/bind_port').with_value('1111') }
    end
  end

  context 'on a RedHat osfamily' do
    let :facts do
      @default_facts.merge({
          :osfamily               => 'RedHat',
          :operatingsystemrelease => '7.0',
          :concat_basedir         => '/var/lib/puppet/concat'
      })
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
      @default_facts.merge({
          :operatingsystemrelease => '7.8',
          :operatingsystem        => 'Debian',
          :osfamily               => 'Debian',
          :concat_basedir         => '/var/lib/puppet/concat'
      })
    end

    it_configures 'murano-api'

    it_behaves_like 'generic murano service', {
        :name         => 'murano-api',
        :package_name => 'murano-api',
        :service_name => 'murano-api'
      }
  end
end
