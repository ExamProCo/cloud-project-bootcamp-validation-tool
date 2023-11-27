module Cpbvt::Payloads::Azure::Commands::VirtualMachine
  def self.included base; base.extend ClassMethods; end
  module ClassMethods
  # ------
  
  # https://learn.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az-vm-list
  def az_virtual_machine_list
    <<~COMMAND
      az vm list
    COMMAND
  end
  
  # ------
  end; end