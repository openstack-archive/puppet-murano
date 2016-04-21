require 'puppet'
require 'spec_helper'
require 'puppet/provider/murano'
require 'tempfile'

describe Puppet::Provider::Murano do

  def klass
    described_class
  end

  let :credential_hash do
    {
      'auth_uri'          => 'https://192.168.56.210:35357',
      'admin_tenant_name' => 'admin_tenant',
      'admin_user'        => 'admin',
      'admin_password'    => 'password',
    }
  end

  let :credential_error do
    /Murano types will not work/
  end

  after :each do
    klass.reset
  end

  describe 'when determining credentials' do

    it 'should fail if config is empty' do
      conf = {}
      klass.expects(:murano_conf).returns(conf)
      expect do
        klass.murano_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should fail if config does not have keystone_authtoken section.' do
      conf = {'foo' => 'bar'}
      klass.expects(:murano_conf).returns(conf)
      expect do
        klass.murano_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should fail if config does not contain all auth params' do
      conf = {'keystone_authtoken' => {'invalid_value' => 'foo'}}
      klass.expects(:murano_conf).returns(conf)
      expect do
        klass.murano_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

  end

  describe 'when invoking the murano cli' do

    it 'should set auth credentials in the environment' do
      authenv = {
        :OS_AUTH_URL      => credential_hash['auth_uri'],
        :OS_USERNAME      => credential_hash['admin_user'],
        :OS_TENANT_NAME   => credential_hash['admin_tenant_name'],
        :OS_PASSWORD      => credential_hash['admin_password'],
        :OS_ENDPOINT_TYPE => 'internalURL',
      }
      klass.expects(:get_murano_credentials).with().returns(credential_hash)
      klass.expects(:withenv).with(authenv)
      klass.auth_murano('test_retries')
    end

    it 'should read auth credentials with specified package service' do
      mock = {
        'keystone_authtoken' => {
          'auth_uri'          => 'https://192.168.56.210:35357',
          'admin_tenant_name' => 'admin_tenant',
          'admin_user'        => 'admin',
          'admin_password'    => 'password',
        },
        'packages_opts' => {
          'packages_service' => 'glance',
        }
      }
      creds = {
         'auth_uri'          => 'https://192.168.56.210:35357',
         'admin_tenant_name' => 'admin_tenant',
         'admin_user'        => 'admin',
         'admin_password'    => 'password',
         'packages_service'  => 'glance',
      }
      Puppet::Util::IniConfig::File.expects(:new).returns(mock)
      mock.expects(:read).with('/etc/murano/murano.conf')
      expect(klass.murano_credentials).to eq(creds)
    end

    it 'should set auth env credentials with specified package service' do
      creds = {
         'auth_uri'          => 'https://192.168.56.210:35357',
         'admin_tenant_name' => 'admin_tenant',
         'admin_user'        => 'admin',
         'admin_password'    => 'password',
         'packages_service'  => 'glance',
      }
      authenv = {
        :OS_AUTH_URL             => creds['auth_uri'],
        :OS_USERNAME             => creds['admin_user'],
        :OS_TENANT_NAME          => creds['admin_tenant_name'],
        :OS_PASSWORD             => creds['admin_password'],
        :OS_ENDPOINT_TYPE        => 'internalURL',
        :MURANO_PACKAGES_SERVICE => creds['packages_service'],
      }
      klass.expects(:get_murano_credentials).with().returns(creds)
      klass.expects(:withenv).with(authenv)
      klass.auth_murano('test_retries')
    end

    ['[Errno 111] Connection refused',
     '(HTTP 400)'].reverse.each do |valid_message|
      it "should retry when murano cli returns with error #{valid_message}" do
        klass.expects(:get_murano_credentials).with().returns({})
        klass.expects(:sleep).with(10).returns(nil)
        klass.expects(:murano).twice.with(['test_retries']).raises(
          Exception, valid_message).then.returns('')
        klass.auth_murano('test_retries')
      end
    end
  end
end
