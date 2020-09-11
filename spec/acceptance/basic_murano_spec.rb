require 'spec_helper_acceptance'

describe 'basic murano' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include openstack_integration
      include openstack_integration::repos
      include openstack_integration::apache
      include openstack_integration::rabbitmq
      include openstack_integration::mysql
      include openstack_integration::keystone

      # Murano resources
      # NOTE(aderyugin): Workaround to fix acceptance tests till murano is not in RDO
      case $::osfamily {
        'Debian': {
          include openstack_integration::murano
        }
        'Redhat': {
          warning('Workaround to fix acceptance tests till murano is not in RDO')
        }
        default: {
          fail("Unsupported osfamily (${::osfamily})")
        }
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(8082), :if => os[:family] == 'debian' do
      it { is_expected.to be_listening.with('tcp') }
    end

  end
end
