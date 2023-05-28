module Cpbvt::Payloads::Aws::Commands::S3api
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# has no region but we just pass it in anyway to make 
# our code my dry elsewhere
# We can't use s2 ls because it won't return json
def s3api_list_buckets(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws s2api list-buckets  \
--output json > #{output_file}
COMMAND
end

#This action is useful to determine if a bucket exists and you have
#permission to access it. The action returns a 200 OK if the bucket
#exists and you have permission to access it.
def s3api_head_bucket(region: output_file:, bucket:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api \ 
head-bucket --bucket #{bucket} \
--output json > #{output_file}
COMMAND
  end

#aws s3api get-bucket-notification-configuration
def s3api_get_bucket_notification_configuration(region:, output_file:,  bucket:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api \
get-bucket-notification-configuration \
--bucket #{bucket} \
--output json > #{output_file}
COMMAND
end

def s3api_get_bucket_policy( output_file:, bucket:)
command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api get-bucket-policy \
--bucket #{bucket} \
--output json > #{output_file}
COMMAND
end
# ------
end; end