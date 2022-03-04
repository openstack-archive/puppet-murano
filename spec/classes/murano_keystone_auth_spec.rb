#
# Unit tests for murano::keystone::auth
#

require 'spec_helper'

describe 'murano::keystone::auth' do
  shared_examples_for 'murano::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'murano_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('murano').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'murano',
        :service_type        => 'application-catalog',
        :service_description => 'Murano Application Catalog',
        :region              => 'RegionOne',
        :auth_name           => 'murano',
        :password            => 'murano_password',
        :email               => 'murano@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:8082',
        :internal_url        => 'http://127.0.0.1:8082',
        :admin_url           => 'http://127.0.0.1:8082',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'murano_password',
          :auth_name           => 'alt_murano',
          :email               => 'alt_murano@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin', 'service'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative Murano Application Catalog',
          :service_name        => 'alt_service',
          :service_type        => 'alt_application-catalog',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('murano').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_application-catalog',
        :service_description => 'Alternative Murano Application Catalog',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_murano',
        :password            => 'murano_password',
        :email               => 'alt_murano@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
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

      it_behaves_like 'murano::keystone::auth'
    end
  end
end
