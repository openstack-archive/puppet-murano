require 'spec_helper'

describe 'murano::db::mysql_cfapi' do

  let :pre_condition do
    ['include mysql::server']
  end

  let :params do
    { :dbname   => 'murano_cfapi',
      :password => 'muranopass',
      :user     => 'murano_cfapi',
      :charset  => 'utf8',
      :collate  => 'utf8_general_ci',
      :host     => '127.0.0.1',
    }
  end

  shared_examples_for 'murano_cfapi mysql database' do

    context 'when omiting the required parameter password' do
      before { params.delete(:password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    it 'creates a mysql database' do
      is_expected.to contain_openstacklib__db__mysql('murano_cfapi').with(
        :user     => params[:user],
        :dbname   => params[:dbname],
        :password => params[:password],
        :host     => params[:host],
        :charset  => params[:charset]
      )
    end

    context 'overriding allowed_hosts param to array' do
      before :each do
        params.merge!(
            :allowed_hosts => ['127.0.0.1','%']
        )
      end

      it {
        is_expected.to contain_openstacklib__db__mysql('murano_cfapi').with(
          :user          => params[:user],
          :dbname        => params[:dbname],
          :password      => params[:password],
          :host          => params[:host],
          :charset       => params[:charset],
          :allowed_hosts => ['127.0.0.1','%']
        )}
    end

    context 'overriding allowed_hosts param to string' do
      before :each do
        params.merge!(
            :allowed_hosts  => '192.168.1.1'
        )
      end

      it {
        is_expected.to contain_openstacklib__db__mysql('murano_cfapi').with(
          :user          => params[:user],
          :dbname        => params[:dbname],
          :password      => params[:password],
          :host          => params[:host],
          :charset       => params[:charset],
          :allowed_hosts => '192.168.1.1'
        )}
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'murano_cfapi mysql database'
    end
  end

end
