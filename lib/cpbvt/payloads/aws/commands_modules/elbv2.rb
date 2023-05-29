module Cpbvt::Payloads::Aws::CommandsModules::Elbv2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# listing ALBs
def elbv2_describe_load_balancers
<<~COMMAND
aws elbv2 describe-load-balancers
COMMAND
end

def elbv2_describe_listeners(load_balancer_arn:)
<<~COMMAND
aws elbv2 describe-listeners \
--load-balancer-arn #{load_balancer_arn} \
--region #{region} --output json > #{output_file}
COMMAND
end

def elbv2_describe_load_balancer_attributes(region:, output_file:, load_balancer_arn:) 
  command = <<~COMMAND.strip.gsub("\n", " ")
aws elbv2 describe-load-balancer-attributes \
--load-balancer-arn #{load_balancer_arn} \
--region #{region} --output json > #{output_file}
COMMAND
end

def elbv2_describe_rules(region:, output_file:,load_balancer_arn:)
command = <<~COMMAND.strip.gsub("\n", " ")
aws elbv2 describe-rules \
--load-balancer-arn #{load_balancer_arn} \
--region #{region} --output json > #{output_file}
COMMAND
end

# listing Target Groups
def elbv2_describe_target_groups(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws elbv2 describe-target-groups \
--region #{region} --output json > #{output_file}
COMMAND
end

def elbv2_describe_target_group_attributes(region:, output_file:,target_group_arn:) 
  command = <<~COMMAND.strip.gsub("\n", " ")
aws elbv2 describe-target-group-attributes \
--target-group-arn target_group_arn \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end