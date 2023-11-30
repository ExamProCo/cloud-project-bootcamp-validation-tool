module Cpbvt::Payloads::Azure::Commands::FunctionApp
  def self.included base; base.extend ClassMethods; end
  module ClassMethods
  # ------
  
  def az_function_app_list resource_group:
    <<~COMMAND
      az functionapp list --resource-group #{resource_group}
    COMMAND
  end
  
  # ------
  end; end