module Cpbvt::Payloads::Aws::Policies::Cloudformation
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudformation_list_stacks
end

def cloudformation_list_stack_resources(stack_name:)
end

# ------
end; end