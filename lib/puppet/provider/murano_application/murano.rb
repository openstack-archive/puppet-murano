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
      n =~ /\s(#{resource[:name]})\s/
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
    opts.push('--is-public') if resource[:public]
    auth_murano('package-import', opts)
  end


  def flush
    if [:present, :latest].include?(resource[:ensure])
      unless resource[:exists_action] == 's'
        opts = [ resource[:package_path] ]
        opts.push('-c').push(resource[:category]) unless resource[:category].nil?
        opts.push('--is-public') if resource[:public]
        opts.push('--exists-action').push(resource[:exists_action])
        auth_murano('package-import', opts)
      end
    end
  end
end
