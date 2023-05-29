module Cpbvt::Payloads::Aws::CommandsModules::Cloudformation
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/list-stacks.html
def cloudformation_list_stacks
<<~COMMAND
aws cloudformation list-stacks
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/list-stack-resources.html
def cloudformation_list_stack_resources(stack_name:)
<<~COMMAND
aws cloudformation list-stack-resources \
--stack-name #{stack_name}
COMMAND
end

# ------
end; end