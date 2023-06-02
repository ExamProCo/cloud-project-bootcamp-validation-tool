module Cpbvt::Payloads::Aws::Commands::Dynamodbstreams
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodbstreams/list-streams.html
def dynamodbstreams_list_streams
<<~COMMAND
aws dynamodbstreams list-streams
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodbstreams/describe-stream.html
def dynamodbstreams_describe_stream(stream_arn:) 
<<~COMMAND
aws dynamodbstreams describe-stream \
--stream-arn #{stream_arn}
COMMAND
end

# ------
end; end