require 'spec_helper'

describe 'murano::config' do

  let :params do
    { :murano_config => {
        'DEFAULT/foo' => { 'value'  => 'fooValue' },
        'DEFAULT/bar' => { 'value'  => 'barValue' },
        'DEFAULT/baz' => { 'ensure' => 'absent' }
      }
    }
  end

  it 'configures arbitrary murano configurations' do
    is_expected.to contain_murano_config('DEFAULT/foo').with_value('fooValue')
    is_expected.to contain_murano_config('DEFAULT/bar').with_value('barValue')
    is_expected.to contain_murano_config('DEFAULT/baz').with_ensure('absent')
  end

end
