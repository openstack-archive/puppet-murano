require 'spec_helper'

describe 'murano::engine' do

  shared_examples_for 'murano-engine' do
    it { is_expected.to contain_class('murano::engine') }

    context 'with default params' do
      it { is_expected.to contain_murano_config('engine/workers').with_value('<SERVICE DEFAULT>') }
    end

    context 'with passed workers' do
      let :params do {
         :workers => '2',
      } end
      it { is_expected.to contain_murano_config('engine/workers').with_value('2') }
    end
  end

  context 'on a RedHat osfamily' do
    let :facts do
      OSDefaults.get_facts({
          :osfamily               => 'RedHat',
          :operatingsystemrelease => '7.0',
          :concat_basedir         => '/var/lib/puppet/concat'
      })
    end

    it_configures 'murano-engine'

    it_behaves_like 'generic murano service', {
        :name         => 'murano-engine',
        :package_name => 'openstack-murano-engine',
        :service_name => 'murano-engine'
      }
  end

  context 'on a Debian osfamily' do
    let :facts do
      OSDefaults.get_facts({
          :operatingsystemrelease => '7.8',
          :operatingsystem        => 'Debian',
          :osfamily               => 'Debian',
          :concat_basedir         => '/var/lib/puppet/concat'
      })
    end

    it_configures 'murano-engine'

    it_behaves_like 'generic murano service', {
      :name         => 'murano-engine',
      :package_name => 'murano-engine',
      :service_name => 'murano-engine'
    }
  end
end
