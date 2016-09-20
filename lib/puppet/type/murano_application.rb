# murano_application type
#
# == Parameters
#  [*name*]
#    Name for the new application
#    Required
#
#  [*package_path*]
#    Path to package file
#    Required
#
#  [*exists_action*]
#    Default action when a package
#    already exists
#    Optional
#
#  [*public*]
#    Make the package available for users
#    from other tenants
#    Optional
#
#  [*category*]
#    Category for the new application
#    Optional
#

require 'puppet'

Puppet::Type.newtype(:murano_application) do

  @doc = 'Manage creation of Murano applications.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Name for the new application'
    validate do |value|
      unless value.is_a? String
        raise ArgumentError, 'name parameter must be a String'
      end
      unless value =~ /^[a-z0-9\.\-_]+$/
        raise ArgumentError, "#{value} is not a valid name"
      end
    end
  end

  newproperty(:package_path) do
    desc 'Path to package file'
    validate do |value|
      unless value.is_a? String
        raise ArgumentError, 'package_path parameter must be a String'
      end
    end
    newvalues(/\S+/)
  end

  newproperty(:exists_action) do
    desc 'Default action when a package already exists'
    defaultto('s')
    validate do |value|
      allowed_actions = ['s', 'a', 'u']
      raise ArgumentError, 'Unknown action is set' unless allowed_actions.include?(value)
    end
  end

  newproperty(:public) do
    desc 'Make the package available for users from other tenants'
    defaultto('true')
    newvalues(/(t|T)rue/, /(f|F)alse/, true, false)
    munge do |value|
      value.to_s.downcase.to_sym
    end
  end

  newproperty(:category) do
    desc 'Package category'
    validate do |value|
      unless value.is_a? String
        raise ArgumentError, 'category parameter must be a String'
      end
    end
  end

  validate do
    raise ArgumentError, 'Name and package path must be set' unless self[:name] and self[:package_path]
  end

end
