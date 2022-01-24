#
# Unit tests for murano::keystone::cfapi_auth
#

require 'spec_helper'

describe 'murano::keystone::cfapi_auth' do
  shared_examples_for 'murano::keystone::cfapi_auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'murano-cfapi_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('murano-cfapi').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => true,
        :service_name        => 'murano-cfapi',
        :service_type        => 'service-broker',
        :service_description => 'Murano Service Broker API',
        :region              => 'RegionOne',
        :auth_name           => 'murano-cfapi',
        :password            => 'murano-cfapi_password',
        :email               => 'murano@localhost',
        :tenant              => 'services',
        :public_url          => 'http://127.0.0.1:8083',
        :internal_url        => 'http://127.0.0.1:8083',
        :admin_url           => 'http://127.0.0.1:8083',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'murano-cfapi_password',
          :auth_name           => 'alt_murano-cfapi',
          :email               => 'alt_murano@alt_localhost',
          :tenant              => 'alt_service',
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative Murano Service Broker API',
          :service_name        => 'alt_service',
          :service_type        => 'alt_service-broker',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('murano-cfapi').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_service-broker',
        :service_description => 'Alternative Murano Service Broker API',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_murano-cfapi',
        :password            => 'murano-cfapi_password',
        :email               => 'alt_murano@alt_localhost',
        :tenant              => 'alt_service',
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'murano::keystone::cfapi_auth'
    end
  end
end
