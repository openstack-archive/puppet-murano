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

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      case facts[:osfamily]
      when 'Debian'
        it_behaves_like 'generic murano service', {
            :name         => 'murano-engine',
            :package_name => 'murano-engine',
            :service_name => 'murano-engine'
          }
      when 'RedHat'
        it_behaves_like 'generic murano service', {
            :name         => 'murano-engine',
            :package_name => 'openstack-murano-engine',
            :service_name => 'murano-engine'
          }
      end

      it_behaves_like 'murano-engine'
    end
  end

end
