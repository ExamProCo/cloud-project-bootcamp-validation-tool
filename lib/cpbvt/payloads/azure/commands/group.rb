module Cpbvt::Payloads::Azure::Commands::Group
  def self.included base; base.extend ClassMethods; end
  module ClassMethods
  # ------
  
  # https://learn.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az-vm-list
  def az_resource_group_list
    <<~COMMAND
      az group list
    COMMAND
  end
  
  # ------
  end; end