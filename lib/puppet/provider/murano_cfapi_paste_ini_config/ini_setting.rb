Puppet::Type.type(:murano_cfapi_paste_ini_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/murano/murano-cfapi-paste.ini'
  end

end
