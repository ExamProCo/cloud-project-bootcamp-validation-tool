module Cpbvt::Payloads::Aws::CommandsModules::S3api
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# has no region but we just pass it in anyway to make 
# our code my dry elsewhere
# We can't use s2 ls because it won't return json
def s3api_list_buckets(output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api list-buckets  \
--output json > #{output_file}
COMMAND
end

#This action is useful to determine if a bucket exists and you have
#permission to access it. The action returns a 200 OK if the bucket
#exists and you have permission to access it.
def s3api_head_bucket(output_file:, bucket:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api \ 
head-bucket --bucket #{bucket} \
--output json > #{output_file}
COMMAND
  end

#aws s3api get-bucket-notification-configuration
def s3api_get_bucket_notification_configuration(output_file:,  bucket:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api \
get-bucket-notification-configuration \
--bucket #{bucket} \
--output json > #{output_file}
COMMAND
end

def s3api_get_bucket_policy(output_file:, bucket:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api get-bucket-policy \
--bucket #{bucket} \
--output json > #{output_file}
COMMAND
end

def s3api_get_bucket_cors(output_file:, bucket:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api get-bucket-cors \
--bucket #{bucket} \
--output json > #{output_file}
COMMAND
end

def s3api_get_bucket_website(output_file:, bucket:)
   command = <<~COMMAND.strip.gsub("\n", " ") 
aws s3api get-bucket-website \
--bucket #{bucket} \
--output json > #{output_file}
COMMAND
end

def s3api_get_object_header(output_file:, bucket:, key:) 
  command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api get-object-metadata \
--bucket #{bucket} \
--key #{key} \
--output json > #{output_file}
COMMAND
end

# special since we are downloading a file
def s3api_get_object(output_file:, bucket:, key:)
   command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api get-object \
--bucket #{bucket} \
--key #{key} \
--output json > #{output_file}
COMMAND
end

def s3api_get_public_access_block(output_file:, bucket:) 
  command = <<~COMMAND.strip.gsub("\n", " ")
aws s3api get-public-access-block \
--bucket #{bucket} \
--output json > #{output_file}
COMMAND
end

def s3api_list_objects_v2(output_file:, bucket:, prefix:)
   command = <<~COMMAND.strip.gsub("\n", " ")
   aws s3api list-objects-v2 \
   --bucket #{bucket} \
   --prefix #{prefix} \
   --output json > #{output_file}
   COMMAND
end

# ------
end; end