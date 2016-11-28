require 'spec_helper'

describe 'murano::cfapi' do

  let(:params) do {
    :tenant => 'admin',
  }
  end

  shared_examples_for 'murano-cfapi' do
    it { is_expected.to contain_class('murano::cfapi') }
  end

  shared_examples_for 'with default parameters' do
    it { is_expected.to contain_class('murano::params') }
    it { is_expected.to contain_class('murano::policy') }

    it { is_expected.to contain_murano_cfapi_config('cfapi/tenant').with_value('admin') }
    it { is_expected.to contain_murano_cfapi_config('cfapi/bind_host').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_cfapi_config('cfapi/bind_port').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_cfapi_config('cfapi/auth_url').with_value('http://127.0.0.1:5000') }
  end

  shared_examples_for 'with parameters override' do
    let :params do {
      :tenant => 'services',
      :bind_host => '0.0.0.0',
      :bind_port => 8080,
      :auth_url => 'http://127.0.0.1:5000/v2.0/'
    }
    end

    it { is_expected.to contain_class('murano::params') }
    it { is_expected.to contain_class('murano::policy') }

    it { is_expected.to contain_murano_cfapi_config('cfapi/tenant').with_value('services') }
    it { is_expected.to contain_murano_cfapi_config('cfapi/bind_host').with_value('0.0.0.0') }
    it { is_expected.to contain_murano_cfapi_config('cfapi/bind_port').with_value(8080) }
    it { is_expected.to contain_murano_cfapi_config('cfapi/auth_url').with_value('http://127.0.0.1:5000/v2.0/') }
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :concat_basedir         => '/var/lib/puppet/concat'
        }))
      end

      it_behaves_like 'murano-cfapi'
      it_behaves_like 'with default parameters'
      it_behaves_like 'with parameters override'

      case facts[:osfamily]
      when 'RedHat'
        it_behaves_like 'generic murano service', {
            :name         => 'murano-cfapi',
            :package_name => 'openstack-murano-cfapi',
            :service_name => 'murano-cfapi',
            :extra_params => {
              :tenant => 'admin',
            },
          }
      when 'Debian'
        it_behaves_like 'generic murano service', {
            :name         => 'murano-cfapi',
            :package_name => 'murano-cfapi',
            :service_name => 'murano-cfapi',
            :extra_params => {
              :tenant => 'admin',
            },
          }
      end
    end
  end

end
