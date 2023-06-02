module Cpbvt::Payloads::Aws::Commands::S3api
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# has no region but we just pass it in anyway to make 
# our code my dry elsewhere
# We can't use s2 ls because it won't return json
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/list-buckets.html
def s3api_list_buckets
<<~COMMAND
aws s3api list-buckets
COMMAND
end

#This action is useful to determine if a bucket exists and you have
#permission to access it. The action returns a 200 OK if the bucket
#exists and you have permission to access it.
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/head-bucket.html
def s3api_head_bucket(bucket:)
<<~COMMAND
aws s3api \ 
head-bucket --bucket #{bucket}
COMMAND
  end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/get-bucket-notification-configuration.html
def s3api_get_bucket_notification_configuration(bucket:)
<<~COMMAND
aws s3api get-bucket-notification-configuration \
--bucket #{bucket}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/get-bucket-policy.html
def s3api_get_bucket_policy(bucket:)
<<~COMMAND
aws s3api get-bucket-policy \
--bucket #{bucket}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/get-bucket-cors.html
def s3api_get_bucket_cors(bucket:)
<<~COMMAND
aws s3api get-bucket-cors \
--bucket #{bucket}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/get-bucket-website.html
def s3api_get_bucket_website(bucket:)
<<~COMMAND
aws s3api get-bucket-website \
--bucket #{bucket}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/head-object.html
def s3api_get_head_object(bucket:, key:) 
<<~COMMAND
aws s3api head-object \
--bucket #{bucket} \
--key #{key}
COMMAND
end

# special since we are downloading a file
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/get-object.html
def s3api_get_object(bucket:, key:)
<<~COMMAND
aws s3api get-object \
--bucket #{bucket} \
--key #{key}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/get-public-access-block.html
def s3api_get_public_access_block(bucket:) 
<<~COMMAND
aws s3api get-public-access-block \
--bucket #{bucket}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/list-objects-v2.html
def s3api_list_objects_v2(bucket:, prefix:)
<<~COMMAND
aws s3api list-objects-v2 \
--bucket #{bucket} \
--prefix #{prefix}
COMMAND
end

# ------
end; end