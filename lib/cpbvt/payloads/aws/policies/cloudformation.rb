module Cpbvt::Payloads::Aws::Policies::Cloudformation
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudformation_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "cloudformation:ListStacks"
    ],
    "Resource" => "*"
  }
end

def cloudformation_list_stack_resources(aws_account_id:,region:,stack_names: [])
  resources = stack_names.map do |stack_name| 
    "arn:aws:cloudformation:#{region}:#{aws_account_id}:stack/#{stack_name}/*"
  end
  resources = "*" if resources.empty?
  {
    "Effect" => "Allow",
    "Action" => "cloudformation:ListStackResources",
    "Resource" => resources
  }
end

# ------
end; end