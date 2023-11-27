module Cpbvt::Payloads::Azure::Commands::Network
  def self.included base; base.extend ClassMethods; end
  module ClassMethods
  # ------
  
  # https://learn.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az-vm-list
  def az_network_vnet_list
    <<~COMMAND
      az network vnet list
    COMMAND
  end
  
  # ------
  end; end