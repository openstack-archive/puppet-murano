require 'spec_helper'

describe 'murano::db::sync' do

  shared_examples_for 'murano-dbsync' do

    it 'runs murano-dbmanage' do
      is_expected.to contain_exec('murano-dbmanage').with(
        :command     => 'murano-db-manage --config-file /etc/murano/murano.conf upgrade',
        :path        => '/usr/bin',
        :user        => 'murano',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end

  end

  context 'on a RedHat osfamily' do
    let :facts do
      {
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '7.0',
        :concat_basedir           => '/var/lib/puppet/concat'
      }
    end

    it_configures 'murano-dbsync'
  end

  context 'on a Debian osfamily' do
    let :facts do
      {
        :operatingsystemrelease => '7.8',
        :operatingsystem        => 'Debian',
        :osfamily               => 'Debian',
        :concat_basedir         => '/var/lib/puppet/concat'
      }
    end

    it_configures 'murano-dbsync'
  end

end
