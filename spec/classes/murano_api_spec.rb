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
            :name         => 'murano-api',
            :package_name => 'murano-api',
            :service_name => 'murano-api'
          }
      when 'RedHat'
        it_behaves_like 'generic murano service', {
            :name         => 'murano-api',
            :package_name => 'openstack-murano-api',
            :service_name => 'murano-api'
          }
      end

      it_behaves_like 'murano-api'
    end
  end

end
