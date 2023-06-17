module Cpbvt::Payloads::Aws::Policies::Cloudformation
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudformation_list_stacks
  {
    "Effect" => "Allow",
    "Action" => "cloudformation:ListStacks",
    "Resource" => "*"
  }
end

def cloudformation_list_stack_resources(stack_name:)
  {
    "Effect" => "Allow",
    "Action" => "cloudformation:ListStackResources",
    "Resource" => "arn:aws:cloudformation:#{region}:#{account_id}:stack/#{stack_name}/*"
  }
end

# ------
end; end