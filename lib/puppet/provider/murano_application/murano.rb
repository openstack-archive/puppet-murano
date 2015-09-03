require File.join(File.dirname(__FILE__), '..','..','..',
                  'puppet/provider/murano')

Puppet::Type.type(:murano_application).provide(
    :murano,
    :parent => Puppet::Provider::Murano
) do

  desc 'Manage murano applications'

  commands :murano => 'murano'

  mk_resource_methods

  def exists?
    packages = auth_murano('package-list')
    return packages.split("\n")[1..-1].detect do |n|
      n =~ /^(\S+)\s+(#{resource[:name]})/
    end
  end

  def destroy
    auth_murano('package-delete', resource[:name])
  end

  def create
    opts = [ resource[:package_path] ]

    unless resource[:category].nil?
      opts.push('-c').push(resource[:category])
    end

    opts.push('--is-public').push('--exists-action').push('u')

    auth_murano('package-import', opts)
  end

end
