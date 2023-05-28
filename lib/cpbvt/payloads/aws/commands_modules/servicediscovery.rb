module Cpbvt::Payloads::Aws::CommandsModules::Servicediscovery
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
def servicediscovery_list_services(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws servicediscovery list-services \
--region #{region} --output json > #{output_file}
COMMAND
end

def servicediscovery_list_namespaces(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws servicediscovery list-namespaces \
--region #{region} --output json > #{output_file}
COMMAND
end
# ------
end; end