module Cpbvt::Payloads::Aws::Commands::Dynamodbstreams
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def dynamodbstreams_list_streams(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws dynamodbstreams list-streams \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end