require 'spec_helper'

describe 'murano::application' do

  let(:title) { 'io.murano' }

  describe 'with default parameters' do
    it { is_expected.to contain_murano_application('io.murano').with(
      :ensure        => 'present',
      :package_path  => '/var/cache/murano/meta/io.murano.zip',
      :public        => true,
      :exists_action => 's'
    )}
  end

  describe 'with package_category override' do
    let :params do {
      :package_category => 'library',
      :public           => false,
      :exists_action    => 'u'
    }
    end

    it { is_expected.to contain_murano_application('io.murano').with(
      :ensure       => 'present',
      :package_path => '/var/cache/murano/meta/io.murano.zip',
      :category     => 'library',
      :public        => false,
      :exists_action => 'u'
    )}
  end

end
