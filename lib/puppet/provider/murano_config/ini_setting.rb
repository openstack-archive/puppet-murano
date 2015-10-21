Puppet::Type.type(:murano_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/murano/murano.conf'
  end

end
