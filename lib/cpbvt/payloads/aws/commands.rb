class Cpbvt::Payloads::Aws::Commands
  def self.ec2_describe_vpcs(region:, output_file:)
    # format the AWS CLI command to be a single line
    command = <<~COMMAND.strip.gsub("\n", " ")
aws ec2 describe-vpcs \
--region #{region} \
--output json \
> #{output_file}
  COMMAND
  end

  # We can't use s3 ls because it won't return json
  def self.s3api_list_buckets(region:, output_file:)
    command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api list-buckets  \
--output json \
> #{output_file}
    COMMAND
  end

  # listing subnets
  def self.ec2_describe_subnets(region:, output_file:)
    command = <<~COMMAND.strip.gsub("\n", " ")
    aws ec2 describe-subnets \
    --region #{region} \
    --output json \
    > #{output_file}
    COMMAND
  end

  # listing route tables
  def self.ec2_describe_route_tables(region:, output_file:)
    command = <<~COMMAND.strip.gsub("\n", " ")
    aws ec2 describe-route-tables \
    --region #{region} \
    --output json \
    > #{output_file}
    COMMAND
  end

  # listing IGWs
  def self.ec2_describe_internet_gateways(region:, output_file:)
    command = <<~COMMAND.strip.gsub("\n", " ")
    aws ec2 describe-internet-gateways \
    --region #{region} \
    --output json \
    > #{output_file}
    COMMAND
  end

  # listing security groups
  def self.ec2_describe_security_groups(region:, output_file:)
    command = <<~COMMAND.strip.gsub("\n", " ")
    aws ec2 describe-security-groups \
    --region #{region} \
    --output json \
    > #{output_file}
    COMMAND
  end

  # listing ALBs
  def self.elbv2_describe_load_balancers(region:, output_file:)
    command = <<~COMMAND.strip.gsub("\n", " ")
    aws elbv2 describe-load-balancers \
    --region #{region} \
    --output json \
    > #{output_file}
    COMMAND
  end

  # listing Target Groups
  def self.elbv2_describe_target_groups(region:, output_file:)
    command = <<~COMMAND.strip.gsub("\n", " ")
    aws elbv2 describe-target-groups \
    --region #{region} \
    --output json \
    > #{output_file}
    COMMAND
  end

  # list RDS instances
  def self.rds_describe_db_instances(region:, output_file:)
    command = <<~COMMAND.strip.gsub("\n", " ")
    aws rds describe-db-instances \
    --region #{region} \
    --output json \
    > #{output_file}
    COMMAND
  end

  # list dynamodb tables
  def self.dynamodb_list_tables(region:, output_file:)
    command = <<~COMMAND.strip.gsub("\n", " ")
    aws dynamodb list-tables \
    --region #{region} \
    --output json \
    > #{output_file}
    COMMAND
  end

  # query against a dynamodb table

  # listing ecr repos
  def self.ecr_describe_repositories(region:, output_file:)
    command = <<~COMMAND.strip.gsub("\n", " ")
    aws ecr describe-repositories \
    --region #{region} \
    --output json \
    > #{output_file}
    COMMAND
  end
end