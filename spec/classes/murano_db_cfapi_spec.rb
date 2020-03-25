require 'spec_helper'

describe 'murano::db_cfapi' do

  shared_examples 'murano::db_cfapi' do

    context 'with default parameters' do
      it { is_expected.to_not contain_murano_cfapi_config('database/connection') }
      it { is_expected.to_not contain_murano_cfapi_config('database/idle_timeout') }
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
          :database_max_retries      => '11',
          :database_retry_interval   => '11',
          :database_max_pool_size    => '11',
          :database_max_overflow     => '21',
          :database_db_max_retries   => '-1',
        }
      end

      it { should contain_oslo__db('murano_cfapi_config').with(
        :connection     => 'mysql+pymysql://murano_cfapi:murano_cfapi@localhost/murano_cfapi',
        :idle_timeout   => '3601',
        :max_pool_size  => '11',
        :max_retries    => '11',
        :retry_interval => '11',
        :max_overflow   => '21',
        :db_max_retries => '-1',
      )}
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
    end
  end

end
