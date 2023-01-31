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
      'auth_url'            => 'https://192.168.56.210:5000',
      'project_name'        => 'admin_tenant',
      'username'            => 'admin',
      'password'            => 'password',
      'project_domain_name' => 'Default',
      'user_domain_name'    => 'Default',

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
      expect(klass).to receive(:murano_conf).and_return(conf)
      expect do
        klass.murano_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should fail if config does not have keystone_authtoken section.' do
      conf = {'foo' => 'bar'}
      expect(klass).to receive(:murano_conf).and_return(conf)
      expect do
        klass.murano_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should fail if config does not contain all auth params' do
      conf = {'keystone_authtoken' => {'invalid_value' => 'foo'}}
      expect(klass).to receive(:murano_conf).and_return(conf)
      expect do
        klass.murano_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

  end

  describe 'when invoking the murano cli' do

    it 'should set auth credentials in the environment' do
      authenv = {
        :OS_AUTH_URL            => credential_hash['auth_url'],
        :OS_USERNAME            => credential_hash['username'],
        :OS_TENANT_NAME         => credential_hash['project_name'],
        :OS_PASSWORD            => credential_hash['password'],
        :OS_ENDPOINT_TYPE       => 'internalURL',
        :OS_PROJECT_DOMAIN_NAME => credential_hash['project_domain_name'],
        :OS_USER_DOMAIN_NAME    => credential_hash['user_domain_name'],

      }
      expect(klass).to receive(:get_murano_credentials).with(no_args).and_return(credential_hash)
      expect(klass).to receive(:withenv).with(authenv)
      klass.auth_murano('test_retries')
    end

    it 'should read auth credentials with specified package service' do
      mock = {
        'keystone_authtoken' => {
          'auth_url'          => 'https://192.168.56.210:5000',
          'project_name'      => 'admin_tenant',
          'username'          => 'admin',
          'password'          => 'password',
        },
        'engine' => {
          'packages_service' => 'glance',
        }
      }
      creds = {
         'auth_url'            => 'https://192.168.56.210:5000',
         'project_name'        => 'admin_tenant',
         'username'            => 'admin',
         'password'            => 'password',
         'packages_service'    => 'glance',
         'project_domain_name' => 'Default',
         'user_domain_name'    => 'Default',
      }
      expect(Puppet::Util::IniConfig::File).to receive(:new).and_return(mock)
      expect(mock).to receive(:read).with('/etc/murano/murano.conf')
      expect(klass.murano_credentials).to eq(creds)
    end

    it 'should set auth env credentials with specified package service' do
      creds = {
         'auth_url'            => 'https://192.168.56.210:5000',
         'project_name'        => 'admin_tenant',
         'username'            => 'admin',
         'password'            => 'password',
         'packages_service'    => 'glance',
         'project_domain_name' => 'Default',
         'user_domain_name'    => 'Default',
      }
      authenv = {
        :OS_AUTH_URL             => creds['auth_url'],
        :OS_USERNAME             => creds['username'],
        :OS_TENANT_NAME          => creds['project_name'],
        :OS_PASSWORD             => creds['password'],
        :OS_ENDPOINT_TYPE        => 'internalURL',
        :MURANO_PACKAGES_SERVICE => creds['packages_service'],
        :OS_PROJECT_DOMAIN_NAME  => creds['project_domain_name'],
        :OS_USER_DOMAIN_NAME     => creds['user_domain_name'],
      }
      expect(klass).to receive(:get_murano_credentials).with(no_args).and_return(creds)
      expect(klass).to receive(:withenv).with(authenv)
      klass.auth_murano('test_retries')
    end

    ['[Errno 111] Connection refused',
     '(HTTP 400)'].reverse.each do |valid_message|
      it "should retry when murano cli returns with error #{valid_message}" do
        expect(klass).to receive(:get_murano_credentials).with(no_args).and_return({})
        expect(klass).to receive(:sleep).with(10).and_return(nil)
        expect(klass).to receive(:murano).with(['test_retries']).and_invoke(
          lambda { |*args| raise Exception, valid_message},
          lambda { |*args| return '' }
        )
        klass.auth_murano('test_retries')
      end
    end
  end
end
