#
# Unit tests for murano::init
#
require 'spec_helper'

describe 'murano' do

  shared_examples_for 'murano' do

    let :params do {
      :admin_password => 'secrete',
      :purge_config   => false,
    }
    end

    context 'with default parameters' do
      it { is_expected.to contain_class('murano::deps') }
      it { is_expected.to contain_class('murano::params') }
      it { is_expected.to contain_class('murano::policy') }
      it { is_expected.to contain_class('murano::db') }

      it { is_expected.to contain_package('murano-common').with({
        :ensure => 'present'
      }) }

      it 'passes purge to resource' do
        is_expected.to contain_resources('murano_config').with({
          :purge => false
        })
      end

      it { is_expected.to contain_class('mysql::bindings::python') }

      it { is_expected.to contain_murano_config('oslo_messaging_notifications/transport_url').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('oslo_messaging_notifications/topics').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('oslo_messaging_notifications/driver').with_value('messagingv2') }

      it { is_expected.to contain_murano_config('murano/url').with_value('http://127.0.0.1:8082') }

      it { is_expected.to contain_murano_config('engine/use_trusts').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_murano_config('DEFAULT/transport_url').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('DEFAULT/rpc_response_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('DEFAULT/control_exchange').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_oslo__messaging__rabbit('murano_config').with(
             :rabbit_use_ssl => '<SERVICE DEFAULT>',
           ) }
      it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_compression').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_murano_config('rabbitmq/login').with_value('guest') }
      it { is_expected.to contain_murano_config('rabbitmq/password').with_value('guest') }
      it { is_expected.to contain_murano_config('rabbitmq/host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('rabbitmq/port').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('rabbitmq/virtual_host').with_value('murano') }
      it { is_expected.to contain_murano_config('rabbitmq/ssl').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_murano_config('networking/default_dns').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('networking/driver').with_value('neutron') }
      it { is_expected.to contain_murano_config('networking/create_router').with_value(true) }
      it { is_expected.to contain_murano_config('networking/external_network').with_value('public') }

      it { is_expected.to contain_murano_config('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/v3') }
      it { is_expected.to contain_murano_config('keystone_authtoken/username').with_value('murano') }
      it { is_expected.to contain_murano_config('keystone_authtoken/project_name').with_value('services') }
      it { is_expected.to contain_murano_config('keystone_authtoken/password').with_value('secrete') }
      it { is_expected.not_to contain_murano_config('keystone_authtoken/auth_url').with_value('http://10.255.0.1:5000/') }
      it { is_expected.to contain_murano_config('keystone_authtoken/user_domain_name').with_value('Default') }
      it { is_expected.to contain_murano_config('keystone_authtoken/project_domain_name').with_value('Default') }
      it { is_expected.to contain_murano_config('keystone_authtoken/memcached_servers').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_murano_config('engine/packages_service').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_exec('murano-dbmanage') }

    end

    context 'with parameters override' do
      let :params do {
        :admin_password             => 'secrete',
        :package_ensure             => 'latest',
        :notification_transport_url => 'rabbit://user:pass@host:1234/virt',
        :notification_topics        => 'openstack',
        :notification_driver        => 'messagingv1',
        :default_transport_url      => 'rabbit://user:pass@host:1234/virt',
        :rpc_response_timeout       => '120',
        :control_exchange           => 'murano',
        :rabbit_ha_queues           => true,
        :rabbit_os_use_ssl          => true,
        :amqp_durable_queues        => true,
        :rabbit_own_host            => '10.255.0.2',
        :rabbit_own_port            => '5674',
        :rabbit_own_user            => 'murano',
        :rabbit_own_password        => 'secrete',
        :rabbit_own_vhost           => 'murano_vhost',
        :rabbit_own_use_ssl         => true,
        :service_url                => 'http://10.255.0.3:8088',
        :service_host               => '10.255.0.3',
        :service_port               => '8088',
        :packages_service           => 'glare',
        :use_ssl                    => true,
        :cert_file                  => '/etc/murano/murano.crt',
        :key_file                   => '/etc/murano/murano.key',
        :ca_file                    => '/etc/murano/ca.crt',
        :use_neutron                => true,
        :external_network           => 'murano-net',
        :default_router             => 'murano-router',
        :default_nameservers        => '["8.8.8.8"]',
        :use_trusts                 => true,
        :sync_db                    => false,
        :admin_user                 => 'muranoy',
        :admin_tenant_name          => 'secrete',
        :auth_uri                   => 'http://10.255.0.1:5000/v2.0/',
        :identity_uri               => 'http://10.255.0.1:5000/',
        :user_domain_name           => 'new_domain',
        :project_domain_name        => 'new_domain',
        :kombu_reconnect_delay      => '1.0',
        :kombu_failover_strategy    => 'round-robin',
        :kombu_compression          => 'gzip',
        :memcached_servers          => '1.1.1.1:11211',
      }
      end

      it { is_expected.to contain_class('murano::params') }
      it { is_expected.to contain_class('murano::policy') }
      it { is_expected.to contain_class('murano::db') }

      it { is_expected.to contain_package('murano-common').with({
        :ensure => 'latest'
      }) }

      it { is_expected.to contain_class('mysql::bindings::python') }

      it { is_expected.to contain_murano_config('oslo_messaging_notifications/transport_url').with_value('rabbit://user:pass@host:1234/virt') }
      it { is_expected.to contain_murano_config('oslo_messaging_notifications/topics').with_value('openstack') }
      it { is_expected.to contain_murano_config('oslo_messaging_notifications/driver').with_value('messagingv1') }

      it { is_expected.to contain_murano_config('murano/url').with_value('http://10.255.0.3:8088') }

      it { is_expected.to contain_murano_config('engine/use_trusts').with_value(true) }

      it { is_expected.to contain_murano_config('DEFAULT/transport_url').with_value('rabbit://user:pass@host:1234/virt') }
      it { is_expected.to contain_murano_config('DEFAULT/rpc_response_timeout').with_value('120') }
      it { is_expected.to contain_murano_config('DEFAULT/control_exchange').with_value('murano') }
      it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true) }
      it { is_expected.to contain_oslo__messaging__rabbit('murano_config').with(
             :rabbit_use_ssl => true,
           ) }

      it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('1.0') }
      it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value('round-robin') }
      it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_compression').with_value('gzip') }
      it { is_expected.to contain_murano_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(true) }

      it { is_expected.to contain_murano_config('rabbitmq/login').with_value('murano') }
      it { is_expected.to contain_murano_config('rabbitmq/password').with_value('secrete') }
      it { is_expected.to contain_murano_config('rabbitmq/host').with_value('10.255.0.2') }
      it { is_expected.to contain_murano_config('rabbitmq/port').with_value('5674') }
      it { is_expected.to contain_murano_config('rabbitmq/virtual_host').with_value('murano_vhost') }
      it { is_expected.to contain_murano_config('rabbitmq/ssl').with_value(true) }

      it { is_expected.to contain_murano_config('keystone_authtoken/auth_uri').with_value('http://10.255.0.1:5000/v2.0/') }
      it { is_expected.to contain_murano_config('keystone_authtoken/username').with_value('muranoy') }
      it { is_expected.to contain_murano_config('keystone_authtoken/project_name').with_value('secrete') }
      it { is_expected.to contain_murano_config('keystone_authtoken/auth_url').with_value('http://10.255.0.1:5000/') }
      it { is_expected.to contain_murano_config('keystone_authtoken/password').with_value('secrete') }
      it { is_expected.to contain_murano_config('keystone_authtoken/memcached_servers').with_value('1.1.1.1:11211') }
      it { is_expected.to contain_murano_config('keystone_authtoken/user_domain_name').with_value('new_domain') }
      it { is_expected.to contain_murano_config('keystone_authtoken/project_domain_name').with_value('new_domain') }

      it { is_expected.to contain_murano_config('networking/external_network').with_value('murano-net') }
      it { is_expected.to contain_murano_config('networking/router_name').with_value('murano-router') }
      it { is_expected.to contain_murano_config('networking/create_router').with_value(true) }
      it { is_expected.to contain_murano_config('networking/default_dns').with_value('["8.8.8.8"]') }
      it { is_expected.to contain_murano_config('networking/driver').with_value('neutron') }

      it { is_expected.to contain_murano_config('ssl/cert_file').with_value('/etc/murano/murano.crt') }
      it { is_expected.to contain_murano_config('ssl/key_file').with_value('/etc/murano/murano.key') }
      it { is_expected.to contain_murano_config('ssl/ca_file').with_value('/etc/murano/ca.crt') }

      it { is_expected.to contain_murano_config('engine/packages_service').with_value('glare') }

      it { is_expected.to_not contain_exec('murano-dbmanage') }

    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'murano'
    end
  end

end
