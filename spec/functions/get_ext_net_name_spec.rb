require 'spec_helper'

describe 'get_ext_net_name' do
  it 'exists' do
    is_expected.not_to eq(nil)
  end

  it 'fails with no arguments' do
    is_expected.to run.with_params.and_raise_error(Puppet::ParseError)
  end

  it 'should return the network name that has router_ext enabled' do
    param = {
      "net04" => {
        "L2" => {
          "router_ext" => false,
        }
      },
      "net04_ext" => {
        "L2" => {
          "router_ext" => true,
        }
      }
    }

    is_expected.to run.with_params(param).and_return('net04_ext')
  end

  it 'should return nil if router_ext is not enabled' do
    param = {
      "net04" => {
        "L2" => {
          "router_ext" => false,
        }
      },
      "net04_ext" => {
        "L2" => {
          "router_ext" => false,
        }
      }
    }

    is_expected.to run.with_params(param).and_return(nil)
  end

  it 'should return nil if there is no router_ext' do
    param = {
      "net04" => {
        "L2" => {}
      },
      "net04_ext" => {
        "L2" => {}
      }
    }

    is_expected.to run.with_params(param).and_return(nil)
  end

  it 'should return nil with empty network data' do
    param = {}
    is_expected.to run.with_params(param).and_return(nil)
  end
end
