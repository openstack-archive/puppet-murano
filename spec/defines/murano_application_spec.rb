require 'spec_helper'

describe 'murano::application' do
  let(:title) { 'io.murano' }

  shared_examples 'murano::application' do
    context 'with default parameters' do
      it { should contain_murano_application('io.murano').with(
        :ensure        => 'present',
        :package_path  => '/var/cache/murano/meta/io.murano.zip',
        :public        => true,
        :exists_action => 's'
      )}
    end

    context 'with package_category override' do
      let :params do
        {
          :package_category => 'library',
          :public           => false,
          :exists_action    => 'u'
        }
      end

      it { should contain_murano_application('io.murano').with(
        :ensure        => 'present',
        :package_path  => '/var/cache/murano/meta/io.murano.zip',
        :category      => 'library',
        :public        => false,
        :exists_action => 'u'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'murano::application'
    end
  end
end
