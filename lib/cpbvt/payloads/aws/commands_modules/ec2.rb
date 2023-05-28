module Cpbvt::Payloads::Aws::CommandsModules::Ec2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def ec2_describe_vpcs(region:, output_file:)
  # format the AWS CLI command to be a single line
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ec2 describe-vpcs \
--region #{region} --output json > #{output_file}
COMMAND
end

# listing subnets
def ec2_describe_subnets(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ec2 describe-subnets \
--region #{region} --output json > #{output_file}
COMMAND
end

# listing route tables
def ec2_describe_route_tables(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ec2 describe-route-tables \
--region #{region} --output json > #{output_file}
COMMAND
end

# listing IGWs
def ec2_describe_internet_gateways(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ec2 describe-internet-gateways \
--region #{region} --output json > #{output_file}
COMMAND
end

# listing security groups
def ec2_describe_security_groups(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ec2 describe-security-groups \
--region #{region} --output json > #{output_file}
COMMAND
end

def ec2_describe_route_tables(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ec2 describe-route-tables \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end