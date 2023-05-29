module Cpbvt::Payloads::Aws::CommandsModules::Rds
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/describe-db-instances.html
def rds_describe_db_instances
<<~COMMAND
aws rds describe-db-instances
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/describe-db-subnet-groups.html
def rds_describe_db_subnet_groups
<<~COMMAND
aws rds describe-db-subnet-groups
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/describe-db-snapshots.html
def rds_describe_db_snapshots
<<~COMMAND
aws rds describe-db-snapshots
COMMAND
end
# ------
end; end