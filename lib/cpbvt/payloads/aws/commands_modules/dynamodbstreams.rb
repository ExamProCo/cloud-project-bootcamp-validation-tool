module Cpbvt::Payloads::Aws::CommandsModules::Dynamodbstreams
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def dynamodbstreams_list_streams(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws dynamodbstreams list-streams \
--region #{region} --output json > #{output_file}
COMMAND
end

def dynamodbstreams_describe_stream(region:, output_file:, stream_arn:) 
  command = <<~COMMAND.strip.gsub("\n", " ")
aws dynamodbstreams describe-stream \
--stream-arn #{stream_arn} \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end