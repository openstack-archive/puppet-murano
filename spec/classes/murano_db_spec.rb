require 'spec_helper'

describe 'murano::db' do

  shared_examples 'murano::db' do

    context 'with default parameters' do
      it { is_expected.to contain_oslo__db('murano_config').with(
        :db_max_retries => '<SERVICE DEFAULT>',
        :connection     => 'mysql://murano:secrete@localhost:3306/murano',
        :idle_timeout   => '<SERVICE DEFAULT>',
        :min_pool_size  => '<SERVICE DEFAULT>',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        { :database_connection       => 'mysql+pymysql://murano:murano@localhost/murano',
          :database_idle_timeout     => '3601',
          :database_min_pool_size    => '2',
          :database_max_retries      => '11',
          :database_retry_interval   => '11',
          :database_max_pool_size    => '11',
          :database_max_overflow     => '21',
          :database_db_max_retries   => '-1',
        }
      end

      it { is_expected.to contain_oslo__db('murano_config').with(
        :db_max_retries => '-1',
        :connection     => 'mysql+pymysql://murano:murano@localhost/murano',
        :idle_timeout   => '3601',
        :min_pool_size  => '2',
        :max_pool_size  => '11',
        :max_retries    => '11',
        :retry_interval => '11',
        :max_overflow   => '21',
      )}
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection => 'postgresql://murano:murano@localhost/murano', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection => 'mysql://murano:murano@localhost/murano', }
      end

      it { is_expected.to contain_package('python-mysqldb').with(:ensure => 'present') }
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'sqlite://murano:murano@localhost/murano', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection => 'foo+pymysql://murano:murano@localhost/murano', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end
  end

on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'murano::db'

      context 'using pymysql driver' do
        let :params do
          { :database_connection => 'mysql+pymysql://murano:murano@localhost/murano' }
        end

        case facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_package('db_backend_package').with(
            :ensure => 'present',
            :name   => 'python-pymysql',
            :tag    => 'openstack'
          )}
        when 'RedHat'
          it { is_expected.not_to contain_package('db_backend_package') }
        end
      end

    end
  end

end
