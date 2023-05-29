module Cpbvt::Payloads::Aws::CommandsModules::Dynamodb
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
  
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/list-tables.html
def dynamodb_list_tables
<<~COMMAND
aws dynamodb list-tables
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/describe-table.html
def dynamodb_describe_table(table_name:)
<<~COMMAND
aws dynamodb \
describe-table \
--table-name #{table_name}
COMMAND
end

# ------
end; end