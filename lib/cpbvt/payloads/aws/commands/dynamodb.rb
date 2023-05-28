module Cpbvt::Payloads::Aws::Commands::Dynamodb
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
  
# list dynamodb tables
def dynamodb_list_tables(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws dynamodb list-tables \
--region #{region} --output json > #{output_file}
COMMAND
end

def dynamodb_describe_table(region:, output_file:, table_name:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws dynamodb \
describe-table \
--table-name #{table_name} \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end