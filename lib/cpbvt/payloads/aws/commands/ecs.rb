module Cpbvt::Payloads::Aws::Commands::Ecs
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
  
def ecs_describe_clusters(region: output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ecs describe-clusters \
--region #{region} --output json > #{output_file}
COMMAND
end

# services is required - a list of services to describe
def ecs_describe_services(region:, output_file:, :services)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ecs describe-services \
--services #{services} \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end