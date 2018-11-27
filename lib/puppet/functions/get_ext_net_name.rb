Puppet::Functions.create_function(:get_ext_net_name) do
  def get_ext_net_name(*args)
    networks = args.first
    raise(Puppet::ParseError, 'get_ext_net_name(): No network data provided!') unless networks.is_a? Hash
    ext_net_array = networks.find { |_, value| value.fetch('L2', {})['router_ext'] }
    return nil unless ext_net_array
    ext_net_array.first
  end
end
