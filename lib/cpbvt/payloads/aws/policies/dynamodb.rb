module Cpbvt::Payloads::Aws::Policies::Dynamodb
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
def dynamodb_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "dynamodb:ListTables"
    ],
    "Resource" => "*"
  }
end
  
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/describe-table.html
def dynamodb_describe_table(aws_account_id:,region:,table_names:[])
  resources = table_names.map do |table_name| 
    "arn:aws:dynamodb:#{region}:#{aws_account_id}:table/#{table_name}"
  end
  resources = "*" if resources.empty?
  {
    "Effect" => "Allow",
    "Action" => "dynamodb:DescribeTable",
    "Resource" => resources
  }
end

# ------
end; end