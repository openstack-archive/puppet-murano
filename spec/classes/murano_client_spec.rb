require 'spec_helper'

describe 'murano::client' do

  shared_examples_for 'murano-client' do
    it { is_expected.to contain_class('murano::client') }
    it { is_expected.to contain_package('python-muranoclient').with(
      :name => 'python-muranoclient',
    )}
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts()) 
      end

      it_configures 'murano-client'
    end
  end
end
