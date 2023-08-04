module Cpbvt::Payloads::Aws::Policies::Rds
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def rds_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "rds:DescribeDBInstances",
      "rds:DescribeDBSubnetGroups",
      "rds:DescribeDBSnapshots"
    ],
    "Resource" => "*"
  }
end
# ------
end; end