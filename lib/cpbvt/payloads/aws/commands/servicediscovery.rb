module Cpbvt::Payloads::Aws::Commands::Servicediscovery
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
def servicediscovery_list_services
  command = <<~COMMAND.strip.gsub("\n", " ")
aws servicediscovery list-services
COMMAND
end

def servicediscovery_list_namespaces
  command = <<~COMMAND.strip.gsub("\n", " ")
aws servicediscovery list-namespaces
COMMAND
end
# ------
end; end