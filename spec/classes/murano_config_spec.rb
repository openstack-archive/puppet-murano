require 'spec_helper'

describe 'murano::config' do
  shared_examples 'murano::config' do
    let :base_config do
      {
        'DEFAULT/foo' => { 'value'  => 'fooValue' },
        'DEFAULT/bar' => { 'value'  => 'barValue' },
        'DEFAULT/baz' => { 'ensure' => 'absent' }
      }
    end

    let :params do
      {
        :murano_config             => base_config,
        :murano_cfapi_config       => base_config,
        :murano_paste_config       => base_config,
        :murano_cfapi_paste_config => base_config
      }
    end

    it { should contain_class('murano::deps') }

    it 'configures arbitrary murano configurations' do
      should contain_murano_config('DEFAULT/foo').with_value('fooValue')
      should contain_murano_config('DEFAULT/bar').with_value('barValue')
      should contain_murano_config('DEFAULT/baz').with_ensure('absent')
    end

    it 'configures murano cfapi configurations' do
      should contain_murano_cfapi_config('DEFAULT/foo').with_value('fooValue')
      should contain_murano_cfapi_config('DEFAULT/bar').with_value('barValue')
      should contain_murano_cfapi_config('DEFAULT/baz').with_ensure('absent')
    end

    it 'configures arbitrary murano paste configurations' do
      should contain_murano_paste_ini_config('DEFAULT/foo').with_value('fooValue')
      should contain_murano_paste_ini_config('DEFAULT/bar').with_value('barValue')
      should contain_murano_paste_ini_config('DEFAULT/baz').with_ensure('absent')
    end

    it 'configures murano cfapi paste configurations' do
      should contain_murano_cfapi_paste_ini_config('DEFAULT/foo').with_value('fooValue')
      should contain_murano_cfapi_paste_ini_config('DEFAULT/bar').with_value('barValue')
      should contain_murano_cfapi_paste_ini_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'murano::config'
    end
  end
end
