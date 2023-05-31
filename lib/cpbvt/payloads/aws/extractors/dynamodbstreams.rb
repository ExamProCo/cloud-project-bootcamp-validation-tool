module Cpbvt::Payloads::Aws::Extractors::Dynamodbstreams
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
def dynamodbstreams_list_streams__stream_arn data
  data['Streams'].map do |t|
    {
      iter_id: t['StreamLabel'],
      stream_arn: t['StreamArn']
    }
  end
end
# ------
end; end