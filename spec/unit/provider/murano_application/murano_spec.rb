require 'puppet'
require 'puppet/provider/murano_application/murano'
require 'tempfile'

provider_class = Puppet::Type.type(:murano_application).provider(:murano)

describe provider_class do

  let :app_attrs do
    {
      :name         => 'io.murano',
      :package_path => '/tmp/io.murano.zip',
      :ensure       => 'present',
    }
  end

  let :resource do
    Puppet::Type::Murano_application.new(app_attrs)
  end

  let :provider do
    provider_class.new(resource)
  end

  shared_examples 'murano_application' do
    describe '#exists?' do
      it 'should check existsing application' do
        provider.class.stubs(:application_exists?).returns(true)
        provider.expects(:auth_murano).with("package-list")
                      .returns('"+----------------------------------+--------------------+----------------------------------------+---------------+-----------+\n| ID                               | Name               | FQN                                    | Author        | Is Public |\n+----------------------------------+--------------------+----------------------------------------+---------------+-----------+\n| 9a23e4aea548462d82b66f2aee0f196e | Core library       | io.murano                              | murano.io     | True      |\n+----------------------------------+--------------------+----------------------------------------+---------------+-----------+\n"')
        provider.exists?
      end

      it 'should check non-existsing application' do
        resource[:name] = 'io.murano.qwe'
        provider.class.stubs(:application_exists?).returns(false)
        provider.expects(:auth_murano).with("package-list")
            .returns('"+----------------------------------+--------------------+----------------------------------------+---------------+-----------+\n| ID                               | Name               | FQN                                    | Author        | Is Public |\n+----------------------------------+--------------------+----------------------------------------+---------------+-----------+\n| 9a23e4aea548462d82b66f2aee0f196e | Core library       | io.murano                              | murano.io     | True      |\n+----------------------------------+--------------------+----------------------------------------+---------------+-----------+\n"')
        provider.exists?
      end
    end

    describe '#create' do
      it 'should create application' do
        provider.expects(:auth_murano).with("package-import", ['/tmp/io.murano.zip', '--is-public', '--exists-action', 'u'] )
                      .returns('')
        provider.create
      end
    end

    describe '#destroy' do
      it 'should destroy application' do
        resource[:ensure] = :absent
        provider.expects(:auth_murano).with("package-delete", 'io.murano')
                      .returns('')
        provider.destroy
      end
    end
  end

  it_behaves_like('murano_application')
end
