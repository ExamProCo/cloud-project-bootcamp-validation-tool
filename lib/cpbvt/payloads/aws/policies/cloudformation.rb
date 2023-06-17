module Cpbvt::Payloads::Aws::Policies::Cloudformation
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudformation_list_stacks(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "cloudformation:ListStacks",
    "Resource" => "*"
  }
end

def cloudformation_list_stack_resources(aws_account_id:,region:,stack_name:)
  {
    "Effect" => "Allow",
    "Action" => "cloudformation:ListStackResources",
    "Resource" => "arn:aws:cloudformation:#{region}:#{account_id}:stack/#{stack_name}/*"
  }
end

# ------
end; end