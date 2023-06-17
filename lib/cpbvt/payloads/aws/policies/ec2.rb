module Cpbvt::Payloads::Aws::Policies::Ec2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-vpcs.html
def ec2_describe_vpcs
  {
    "Sid" => "AllowEC2DescribeVPCs",
    "Effect" => "Allow",
    "Action" => "ec2:DescribeVpcs",
    "Resource" => "*",
    "Condition" => {
      "StringEquals" => {
        "ec2:Region" => region
      }
    }
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-subnets.html
def ec2_describe_subnets
  {
    "Sid" => "AllowEC2DescribeSubnets",
    "Effect" => "Allow",
    "Action" => "ec2:DescribeSubnets",
    "Resource" => "*",
    "Condition" => {
      "StringEquals" => {
        "ec2:Region" => region
        }
    }
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-route-tables.html
def ec2_describe_route_tables
  {
    "Effect" => "Allow",
    "Action" => "ec2:DescribeRouteTables",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-internet-gateways.html
def ec2_describe_internet_gateways
  {
    "Effect" => "Allow",
    "Action" => "ec2:DescribeInternetGateways",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-security-groups.html
def ec2_describe_security_groups
  {
    "Effect" => "Allow",
    "Action" => "ec2:DescribeSecurityGroups",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-route-tables.html
def ec2_describe_route_tables
  {
    "Effect" => "Allow",
    "Action" => "ec2:DescribeRouteTables",
    "Resource" => "*"
}
end

# ------
end; end