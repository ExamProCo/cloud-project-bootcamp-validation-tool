module Cpbvt::Payloads::Aws::Extractors::S3api
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def s3api_list_buckets__bucket data
  data['Buckets'].map do |t|
    name = t['Name']
    {
      iter_id: name,
      bucket: name
    }
  end
end

# ------
end; end