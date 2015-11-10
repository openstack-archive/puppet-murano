require 'spec_helper'

describe 'murano::client' do

  shared_examples_for 'murano-client' do
    it { is_expected.to contain_class('murano::client') }
    it { is_expected.to contain_package('python-muranoclient').with(
      :name => 'python-muranoclient',
    )}
  end

  context 'on Debian platforms' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      }
    end

    it_configures 'murano-client'
  end
end
