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

def rds_describe_db_security_groups(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws rds describe-db-security-groups \
--region #{region} --output json > #{output_file}
COMMAND
end

def rds_describe_db_subnet_groups(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws rds describe-db-subnet-groups \
--region #{region} --output json > #{output_file}
COMMAND
end

def rds_describe_db_snapshots(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws rds describe-db-snapshots \
--region #{region} --output json > #{output_file}
COMMAND
end
# ------
end; end