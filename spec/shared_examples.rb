shared_examples_for "a Puppet::Error" do |description|
  it "with message matching #{description.inspect}" do
    expect { is_expected.to have_class_count(1) }.to raise_error(Puppet::Error, description)
  end
end

shared_examples 'generic murano service' do |service|

  context 'with default parameters' do
    let :context_params do
      { }
    end

    it 'installs package and service' do
      is_expected.to contain_package(service[:name]).with({
        :name   => service[:package_name],
        :ensure => 'present',
        :tag    => [ 'openstack', 'murano-package'],
      })
      is_expected.to contain_service(service[:name]).with({
        :name   => service[:service_name],
        :ensure => 'running',
        :enable => true,
        :tag    => 'murano-service',
      })
    end
  end

  context 'with overridden parameters' do
    let :context_params do
      { :enabled        => true,
        :package_ensure => '2014.2-1' }
    end

    let :params do
      context_params.merge(service[:extra_params].nil? ? {} : service[:extra_params])
    end

    it 'installs package and service' do
      is_expected.to contain_package(service[:name]).with({
        :name   => service[:package_name],
        :ensure => '2014.2-1',
        :tag    => [ 'openstack', 'murano-package'],
      })
      is_expected.to contain_service(service[:name]).with({
        :name   => service[:service_name],
        :ensure => 'running',
        :enable => true,
        :tag    => 'murano-service',
      })
    end
  end

  context 'while not managing service state' do
    let :context_params do
      { :enabled        => false,
        :manage_service => false }
    end

    let :params do
      context_params.merge(service[:extra_params].nil? ? {} : service[:extra_params])
    end

    it 'does not control service state' do
      is_expected.to contain_service(service[:name]).without_ensure
    end
  end
end
