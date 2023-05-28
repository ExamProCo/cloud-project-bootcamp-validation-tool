module Cpbvt::Payloads::Aws::Commands::Rds
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# list RDS instances
def rds_describe_db_instances(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws rds describe-db-instances \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end