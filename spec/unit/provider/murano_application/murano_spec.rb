require 'puppet'
require 'puppet/provider/murano_application/murano'
require 'tempfile'

provider_class = Puppet::Type.type(:murano_application).provider(:murano)

describe provider_class do

  let :app_attrs do
    {
      :name          => 'io.murano',
      :package_path  => '/tmp/io.murano.zip',
      :ensure        => 'present',
      :public        => true,
      :exists_action => 'u',
    }
  end

  let :resource do
    Puppet::Type::Murano_application.new(app_attrs)
  end

  let :provider do
    provider_class.new(resource)
  end

  shared_examples 'murano_application' do
    describe '#create' do
      it 'should create application' do
        expect(provider).to receive(:auth_murano).with("package-import", ['/tmp/io.murano.zip', '--is-public'] )
          .and_return('')
        provider.create
      end
    end

    describe '#flush' do
      it 'should flush application' do
        expect(provider).to receive(:auth_murano).with("package-import", ['/tmp/io.murano.zip', '--is-public', '--exists-action', 'u'] )
          .and_return('')
        provider.flush
      end
    end

    describe '#destroy' do
      it 'should destroy application' do
        resource[:ensure] = :absent
        expect(provider).to receive(:auth_murano).with("package-delete", 'io.murano')
          .and_return('')
        provider.destroy
      end
    end

    describe '#instances' do
      it 'finds packages' do
        expect(provider.class).to receive(:auth_murano).with("package-list")
          .and_return("+----------------------------------+--------------------+----------------------------------------+---------------+-----------+\n| ID                               | Name               | FQN                                    | Author        | Is Public |\n+----------------------------------+--------------------+----------------------------------------+---------------+-----------+\n| 9a23e4aea548462d82b66f2aee0f196e | Core library       | io.murano                              | murano.io     | True      |\n+----------------------------------+--------------------+----------------------------------------+---------------+-----------+\n")
        instances = provider_class.instances
        expect(instances.count).to eq(1)
        expect(instances[0].name).to eq('io.murano')
        expect(instances[0].public).to eq('true')
        expect(instances[0].package_path).to eq('/var/cache/murano/meta/io.murano.zip')
        expect(instances[0].exists_action).to eq('s')
      end
    end
  end

  it_behaves_like('murano_application')
end
