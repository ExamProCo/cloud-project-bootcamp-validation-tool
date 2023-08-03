module Cpbvt::Payloads::Aws::Policies::Dynamodbstreams
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def dynamodbstreams_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "dynamodb:ListTables",
      "dynamodb:DescribeTable"
    ],
    "Resource" => "*"
  }
end

# ------
end; end