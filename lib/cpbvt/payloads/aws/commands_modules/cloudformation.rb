module Cpbvt::Payloads::Aws::CommandsModules::Cloudformation
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudformation_list_stacks(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cloudformation list-stacks \
--region #{region} --output json > #{output_file}
COMMAND
end

def cloudformation_list_stack_resources(region:, output_file:, stack_name:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cloudformation list-stack-resources \
--stack-name #{stack_name} \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end