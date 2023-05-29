module Cpbvt::Payloads::Aws::CommandsModules::Ec2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-vpcs.html
def ec2_describe_vpcs
<<~COMMAND
aws ec2 describe-vpcs
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-subnets.html
def ec2_describe_subnets
<<~COMMAND
aws ec2 describe-subnets
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-route-tables.html
def ec2_describe_route_tables
<<~COMMAND
aws ec2 describe-route-tables
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-internet-gateways.html
def ec2_describe_internet_gateways
<<~COMMAND
aws ec2 describe-internet-gateways
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-security-groups.html
def ec2_describe_security_groups
<<~COMMAND
aws ec2 describe-security-groups
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-route-tables.html
def ec2_describe_route_tables
<<~COMMAND
aws ec2 describe-route-tables
COMMAND
end

# ------
end; end