module Cpbvt::Payloads::Aws::Extractors::S3api
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def s3api_list_buckets__bucket data, filters={}
  data['Buckets'].filter_map do |t|
    result = true

    name = t['Name']
    if filters.key?(:bucket_names) && filters[:bucket_names].any?
      result = filters[:bucket_names].include?(name)
    end

    if result
      {
        iter_id: name,
        bucket: name
      }
    end
  end # .filter_map
end

# ------
end; end