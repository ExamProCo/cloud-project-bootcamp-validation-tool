module Cpbvt::Payloads::Aws::Policies::Dynamodbstreams
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodbstreams/list-streams.html
def dynamodbstreams_list_streams
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodbstreams/describe-stream.html
def dynamodbstreams_describe_stream(stream_arn:) 
end

# ------
end; end