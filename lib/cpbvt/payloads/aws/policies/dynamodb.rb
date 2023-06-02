module Cpbvt::Payloads::Aws::Policies::Dynamodb
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
  
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/list-tables.html
def dynamodb_list_tables
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/describe-table.html
def dynamodb_describe_table(table_name:)
end

# ------
end; end