require 'spec_helper'

describe 'murano::db::sync_cfapi' do

  shared_examples_for 'murano-dbsync-cfapi' do

    it 'runs murano-cfapi-dbmanage' do
      is_expected.to contain_exec('murano-cfapi-dbmanage').with(
        :command     => 'murano-cfapi-db-manage --config-file /etc/murano/murano-cfapi.conf upgrade',
        :path        => '/usr/bin',
        :user        => 'murano_cfapi',
        :refreshonly => 'true',
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[murano::install::end]',
                         'Anchor[murano::config::end]',
                         'Anchor[murano::dbsync::begin]'],
        :notify      => 'Anchor[murano::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_configures 'murano-dbsync-cfapi'
    end
  end

end
