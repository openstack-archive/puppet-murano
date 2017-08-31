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
    packages = self.package_list_cleanup(auth_murano('package-list'))
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

  def self.instances
    packages = self.package_list_cleanup(auth_murano('package-list'))
    packages.split("\n")[3..-2].collect do |n|
      new({
        :name => n.split("|")[3][/([^\s]+)/],
        :exists_action => 's',
        :package_path => '/var/cache/murano/meta/' + n.split("|")[3][/([^\s]+)/] + '.zip',
        :public => (n.split("|")[5][/([^\s]+)/] == 'True').to_s,
        :ensure => :present
      })
    end
  end

  def self.prefetch(resources)
    packages = instances
    resources.keys.each do |name|
      if provider = packages.find{ |package| package.name == name }
        resources[name].provider = provider
      end
    end
  end

def self.package_list_cleanup(text)
    return nil if text.nil?
    # The murano package-list valid output should only start by + or |
    text=text.split("\n").drop_while { |line| line !~ /^(\+|\|)/ }.join("\n")
    "#{text}\n"
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
