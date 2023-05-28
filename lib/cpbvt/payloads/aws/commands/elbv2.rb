module Cpbvt::Payloads::Aws::Commands::Elbv2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# listing ALBs
def elbv2_describe_load_balancers(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws elbv2 describe-load-balancers \
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

# ------
end; end