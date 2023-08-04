module Cpbvt::Payloads::Aws::Policies::Ec2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def ec2_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeRouteTables",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeSecurityGroups"
    ],
    "Resource" => "*"
  }
end

# ------
end; end