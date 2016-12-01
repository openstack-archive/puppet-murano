require 'spec_helper'

describe 'murano::db::postgresql_cfapi' do

  shared_examples_for 'murano::db::postgresql_cfapi' do
    let :req_params do
      { :password => 'pw' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_postgresql__server__db('murano_cfapi').with(
        :user     => 'murano_cfapi',
        :password => 'md594583175c7aca1cf386f1c97c50fda19'
      )}
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'murano::db::postgresql_cfapi'
    end
  end

end
