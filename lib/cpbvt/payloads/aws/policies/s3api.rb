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
  resources = "*" if resources.empty?
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

# ------
end; end