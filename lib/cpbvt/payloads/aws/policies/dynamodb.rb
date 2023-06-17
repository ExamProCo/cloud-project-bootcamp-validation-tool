module Cpbvt::Payloads::Aws::Policies::Dynamodb
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
  
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/list-tables.html
def dynamodb_list_tables
  {
    "Effect" => "Allow",
    "Action" => "dynamodb:ListTables",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/describe-table.html
def dynamodb_describe_table(table_name:)
  {
    "Effect" => "Allow",
    "Action" => "dynamodb:DescribeTable",
    "Resource" => "*"
  }
end

# ------
end; end