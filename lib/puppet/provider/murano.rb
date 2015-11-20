require 'puppet/util/inifile'

class Puppet::Provider::Murano < Puppet::Provider

  def self.conf_filename
    '/etc/murano/murano.conf'
  end

  def self.withenv(hash, &block)
    saved = ENV.to_hash
    hash.each do |name, val|
      ENV[name.to_s] = val
    end

    yield
  ensure
    ENV.clear
    saved.each do |name, val|
      ENV[name] = val
    end
  end

  def self.murano_conf
    return @murano_conf if @murano_conf
    @murano_conf = Puppet::Util::IniConfig::File.new
    @murano_conf.read(conf_filename)
    @murano_conf
  end

  def self.murano_credentials
    @murano_credentials ||= get_murano_credentials
  end

  def murano_credentials
    self.class.murano_credentials
  end

  def self.get_murano_credentials
    #needed keys for authentication
    auth_keys = ['auth_uri', 'admin_tenant_name', 'admin_user', 'admin_password']
    conf = murano_conf
    if conf and conf['keystone_authtoken'] and
        auth_keys.all?{|k| !conf['keystone_authtoken'][k].nil?}
      return Hash[ auth_keys.map { |k| [k, conf['keystone_authtoken'][k].strip] } ]
    else
      raise(Puppet::Error, "File: #{conf_filename} does not contain all " +
                             'required sections. Murano types will not work if murano is not ' +
                             'correctly configured.')
    end
  end

  def self.auth_murano(*args)
    m = murano_credentials
    authenv = {
        :OS_AUTH_URL      => m['auth_uri'],
        :OS_USERNAME      => m['admin_user'],
        :OS_TENANT_NAME   => m['admin_tenant_name'],
        :OS_PASSWORD      => m['admin_password'],
        :OS_ENDPOINT_TYPE => 'internalURL'
    }
    begin
      withenv authenv do
        murano(args)
      end
    rescue Exception => e
      if (e.message =~ /\[Errno 111\] Connection refused/) or
          (e.message =~ /\(HTTP 400\)/)
        sleep 10
        withenv authenv do
          murano(args)
        end
      else
        raise(e)
      end
    end
  end

  def auth_murano(*args)
    self.class.auth_murano(args)
  end

  def self.reset
    @murano_conf = nil
    @murano_credentials = nil
  end

end
