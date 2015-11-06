require 'spec_helper_acceptance'

describe 'basic murano' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      # Common resources
      case $::osfamily {
        'Debian': {
          include ::apt
          class { '::openstack_extras::repo::debian::ubuntu':
            release         => 'liberty',
            package_require => true,
          }
          $package_provider = 'apt'
        }
        'RedHat': {
          class { '::openstack_extras::repo::redhat::redhat':
            release => 'liberty',
          }
          package { 'openstack-selinux': ensure => 'latest' }
          $package_provider = 'yum'
        }
        default: {
          fail("Unsupported osfamily (${::osfamily})")
        }
      }

      class { '::mysql::server': }

      class { '::rabbitmq':
        delete_guest_user => true,
        package_provider  => $package_provider,
      }

      rabbitmq_vhost { '/':
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

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

      # Keystone resources, needed by Murano to run
      class { '::keystone::db::mysql':
        password => 'keystone',
      }
      class { '::keystone':
        verbose             => true,
        debug               => true,
        database_connection => 'mysql://keystone:keystone@127.0.0.1/keystone',
        admin_token         => 'admin_token',
        enabled             => true,
      }
      class { '::keystone::roles::admin':
        email    => 'test@example.tld',
        password => 'a_big_secret',
      }
      class { '::keystone::endpoint':
        public_url => "https://${::fqdn}:5000/",
        admin_url  => "https://${::fqdn}:35357/",
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
            database_connection     => 'mysql://murano:a_big_secret@127.0.0.1/murano?charset=utf8',
          }
          class { '::murano::api': }
          class { '::murano::engine': }
          class { '::murano::keystone::auth':
            password => 'a_big_secret',
          }

          Class['::keystone'] -> Class['::murano::db::mysql']
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
