require 'spec_helper'

describe 'murano::config' do

  let :base_config do
    {
        'DEFAULT/foo' => { 'value'  => 'fooValue' },
        'DEFAULT/bar' => { 'value'  => 'barValue' },
        'DEFAULT/baz' => { 'ensure' => 'absent' }
    }
  end

  let :params do
    { :murano_config => base_config,
      :murano_cfapi_config => base_config,
      :murano_paste_config => base_config,
      :murano_cfapi_paste_config => base_config
    }
  end

  it 'configures arbitrary murano configurations' do
    is_expected.to contain_murano_config('DEFAULT/foo').with_value('fooValue')
    is_expected.to contain_murano_config('DEFAULT/bar').with_value('barValue')
    is_expected.to contain_murano_config('DEFAULT/baz').with_ensure('absent')
  end

  it 'configures murano cfapi configurations' do
    is_expected.to contain_murano_cfapi_config('DEFAULT/foo').with_value('fooValue')
    is_expected.to contain_murano_cfapi_config('DEFAULT/bar').with_value('barValue')
    is_expected.to contain_murano_cfapi_config('DEFAULT/baz').with_ensure('absent')
  end

  it 'configures arbitrary murano paste configurations' do
    is_expected.to contain_murano_paste_ini_config('DEFAULT/foo').with_value('fooValue')
    is_expected.to contain_murano_paste_ini_config('DEFAULT/bar').with_value('barValue')
    is_expected.to contain_murano_paste_ini_config('DEFAULT/baz').with_ensure('absent')
  end

  it 'configures murano cfapi paste configurations' do
    is_expected.to contain_murano_cfapi_paste_ini_config('DEFAULT/foo').with_value('fooValue')
    is_expected.to contain_murano_cfapi_paste_ini_config('DEFAULT/bar').with_value('barValue')
    is_expected.to contain_murano_cfapi_paste_ini_config('DEFAULT/baz').with_ensure('absent')
  end

end
