require 'puppet'
require 'puppet/type/murano_application'
describe 'Puppet::Type.type(:murano_application)' do
  it 'should fail without package path' do
    expect { Puppet::Type.type(:murano_application).new(:name => 'io.murano') }.to raise_error(Puppet::Error, /Name and package path must be set/)
  end

  it 'should reject an invalid name' do
    expect { Puppet::Type.type(:murano_application).new(:name => 8082, :package_path => '/tmp/io.zip') }.to raise_error(Puppet::Error, /name parameter must be a String/)
    expect { Puppet::Type.type(:murano_application).new(:name => 'io.murano.@', :package_path => '/tmp/io.zip') }.to raise_error(Puppet::Error, /is not a valid name/)
  end

  it 'should reject an invalid package path' do
    expect { Puppet::Type.type(:murano_application).new(:name => 'io.murano', :package_path => 8082) }.to raise_error(Puppet::Error, /package_path parameter must be a String/)
  end

  it 'should reject an invalid category' do
    expect { Puppet::Type.type(:murano_application).new(:name => 'io.murano', :package_path => '/tmp/io.zip', :category => 8082) }.to raise_error(Puppet::Error, /category parameter must be a String/)
  end

  it 'should accept valid parameters' do
    Puppet::Type.type(:murano_application).new(:name => 'io.murano', :package_path => '/tmp/io.zip', :category => 'library')
  end

end
