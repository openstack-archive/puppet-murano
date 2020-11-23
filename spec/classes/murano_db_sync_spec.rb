require 'spec_helper'

describe 'murano::db::sync' do

  shared_examples_for 'murano-dbsync' do

    it { is_expected.to contain_class('murano::deps') }

    it 'runs murano-dbmanage' do
      is_expected.to contain_exec('murano-dbmanage').with(
        :command     => 'murano-db-manage --config-file /etc/murano/murano.conf upgrade',
        :path        => '/usr/bin',
        :user        => 'murano',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
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
        facts.merge(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'murano-dbsync'
    end
  end

end
