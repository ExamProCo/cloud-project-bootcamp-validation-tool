module Cpbvt::Payloads::Aws::CommandsModules::Cloudformation
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/list-stacks.html
# If we don't specify a stack status filter, the output includes all stacks.
# We really only want to see currently deployed stacks.
def cloudformation_list_stacks
<<~COMMAND
aws cloudformation list-stacks \
--stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE 
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