module Cpbvt::Payloads::Aws::Policies::S3api
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def s3api_allow_general_permissions(aws_account_id:)
  {
    "Effect" => "Allow",
    "Action" => [
      "s3:ListAllMyBuckets"
    ],
    "Resource" => "*"
  }
end

def s3api_allow_scoped_permissions(aws_account_id:,bucket_names: [])
  resources = bucket_names.map{|b|"arn:aws:s3:::#{b}/*"}
  if resources.empty?
    resources = "*" 
  else
    bucket_names.each do |bucket|
      resources.push "arn:aws:s3:::#{bucket}"
    end
  end
  {
    "Effect" => "Allow",
    "Action" => [
      "s3:HeadBucket",
      "s3:GetBucketNotification",
      "s3:GetBucketPolicy",
      "s3:GetBucketCors",
      "s3:GetBucketWebsite",
      "s3:GetObject",
      "s3:HeadObject",
      "s3:GetObjectAcl",
      "s3:GetBucketPublicAccessBlock"
    ],
    "Resource" => resources
  }
end

def s3api_get_head_object(aws_account_id:,bucket: '*', key: '*')
  {
    "Effect" => "Allow",
    "Action" => [
        "s3:GetObject",
        "s3:HeadObject",
        "s3:GetObjectAcl"
    ],
    "Resource" => "arn:aws:s3:::#{bucket}/#{key}"
  }
end

# ------
end; end