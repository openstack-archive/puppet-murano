require 'spec_helper'

describe 'murano::db_cfapi' do

  shared_examples 'murano::db_cfapi' do

    context 'with default parameters' do
      it { is_expected.to_not contain_murano_cfapi_config('database/connection') }
      it { is_expected.to_not contain_murano_cfapi_config('database/idle_timeout') }
      it { is_expected.to_not contain_murano_cfapi_config('database/min_pool_size') }
      it { is_expected.to_not contain_murano_cfapi_config('database/max_retries') }
      it { is_expected.to_not contain_murano_cfapi_config('database/retry_interval') }
      it { is_expected.to_not contain_murano_cfapi_config('database/max_pool_size') }
      it { is_expected.to_not contain_murano_cfapi_config('database/max_overflow') }
      it { is_expected.to_not contain_murano_cfapi_config('database/db_max_retries') }
    end

    context 'with specific parameters' do
      let :params do
        { :database_connection       => 'mysql+pymysql://murano_cfapi:murano_cfapi@localhost/murano_cfapi',
          :database_idle_timeout     => '3601',
          :database_min_pool_size    => '2',
          :database_max_retries      => '11',
          :database_retry_interval   => '11',
          :database_max_pool_size    => '11',
          :database_max_overflow     => '21',
          :database_db_max_retries   => '-1',
        }
      end

      it { is_expected.to contain_murano_cfapi_config('database/connection').with_value('mysql+pymysql://murano_cfapi:murano_cfapi@localhost/murano_cfapi') }
      it { is_expected.to contain_murano_cfapi_config('database/idle_timeout').with_value('3601') }
      it { is_expected.to contain_murano_cfapi_config('database/min_pool_size').with_value('2') }
      it { is_expected.to contain_murano_cfapi_config('database/max_retries').with_value('11') }
      it { is_expected.to contain_murano_cfapi_config('database/retry_interval').with_value('11') }
      it { is_expected.to contain_murano_cfapi_config('database/max_pool_size').with_value('11') }
      it { is_expected.to contain_murano_cfapi_config('database/max_overflow').with_value('21') }
      it { is_expected.to contain_murano_cfapi_config('database/db_max_retries').with_value('-1') }
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection     => 'postgresql://murano_cfapi:murano_cfapi@localhost/murano_cfapi', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection     => 'mysql://murano_cfapi:murano_cfapi@localhost/murano_cfapi', }
      end

      it { is_expected.to contain_package('python-mysqldb').with(:ensure => 'present') }
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'sqlite://murano_cfapi:murano_cfapi@localhost/murano_cfapi', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection     => 'foo+pymysql://murano_cfapi:murano_cfapi@localhost/murano_cfapi', }
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

      it_behaves_like 'murano::db_cfapi'

      context 'using pymysql driver' do
        let :params do
          { :database_connection     => 'mysql+pymysql://murano_cfapi:murano_cfapi@localhost/murano_cfapi' }
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
