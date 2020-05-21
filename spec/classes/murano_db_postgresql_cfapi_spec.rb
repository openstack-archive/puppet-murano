require 'spec_helper'

describe 'murano::db::postgresql_cfapi' do

  shared_examples_for 'murano::db::postgresql_cfapi' do
    let :req_params do
      { :password => 'muranopass' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_openstacklib__db__postgresql('murano_cfapi').with(
        :user       => 'murano_cfapi',
        :password   => 'muranopass',
        :dbname     => 'murano_cfapi',
        :encoding   => nil,
        :privileges => 'ALL',
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
