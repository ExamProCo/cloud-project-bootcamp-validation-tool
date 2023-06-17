module Cpbvt::Payloads::Aws::Policies::Rds
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/describe-db-instances.html
def rds_describe_db_instances
  {
    "Effect" => "Allow",
    "Action" => "rds:DescribeDBInstances",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/describe-db-subnet-groups.html
def rds_describe_db_subnet_groups
  {
    "Effect" => "Allow",
    "Action" => "rds:DescribeDBSubnetGroups",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/describe-db-snapshots.html
def rds_describe_db_snapshots
  {
    "Effect" => "Allow",
    "Action" => "rds:DescribeDBSnapshots",
    "Resource" => "*"
  }
end
# ------
end; end