require 'spec_helper_acceptance'

describe 'basic murano' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      rabbitmq_vhost { '/murano':
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }
      rabbitmq_user { 'murano':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }
      rabbitmq_user_permissions { 'murano@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }
      rabbitmq_user_permissions { 'murano@/murano':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Murano resources
      # NOTE(aderyugin): Workaround to fix acceptance tests till murano is not in RDO
      case $::osfamily {
        'Debian': {
          class { '::murano::db::mysql':
            password => 'a_big_secret',
          }
          class { '::murano':
            admin_password          => 'a_big_secret',
            rabbit_os_user          => 'murano',
            rabbit_os_password      => 'an_even_bigger_secret',
            rabbit_own_user         => 'murano',
            rabbit_own_password     => 'an_even_bigger_secret',
            rabbit_own_vhost        => '/murano',
            database_connection     => 'mysql+pymysql://murano:a_big_secret@127.0.0.1/murano?charset=utf8',
          }
          class { '::murano::api': }
          class { '::murano::engine': }
          class { '::murano::keystone::auth':
            password => 'a_big_secret',
          }
        }
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(8082), :if => os[:family] == 'debian' do
      it { is_expected.to be_listening.with('tcp') }
    end

  end
end
