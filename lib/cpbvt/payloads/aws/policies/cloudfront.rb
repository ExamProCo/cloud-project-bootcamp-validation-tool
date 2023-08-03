module Cpbvt::Payloads::Aws::Policies::Cloudfront
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudfront_allow_general_permissions(aws_account_id:)
  {
    "Effect" => "Allow",
    "Action" => [
      "cloudfront:ListDistributions",
      "cloudfront:GetDistribution",
      "cloudfront:ListInvalidations",
      "cloudfront:ListCloudFrontOriginAccessIdentities",
      "cloudfront:GetCloudFrontOriginAccessIdentity",
      "cloudfront:GetCloudFrontOriginAccessIdentityConfig"
    ],
    "Resource" => "*"
  }
end
  
# ------
end; end