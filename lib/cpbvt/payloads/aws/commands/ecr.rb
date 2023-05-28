module Cpbvt::Payloads::Aws::Commands::Ecr
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# listing ecr repos
def ecr_describe_repositories(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ecr describe-repositories \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end