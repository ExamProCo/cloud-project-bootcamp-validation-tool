module Cpbvt::Payloads::Aws::Policies::Cloudfront
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/list-distributions.html
def cloudfront_list_distributions
  {
    "Effect" => "Allow",
    "Action" => "cloudfront:ListDistributions",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/get-distribution.html
def cloudfront_get_distribution(distribution_id:)
  {
    "Effect" => "Allow",
    "Action" => "cloudfront:GetDistribution",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/list-invalidations.html
def cloudfront_list_invalidations(distribution_id:)
  {
    "Effect" => "Allow",
    "Action" => "cloudfront:ListInvalidations",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/list-cloud-front-origin-access-identities.html
def cloudfront_list_cloud_front_origin_access_identities
  {
    "Effect" => "Allow",
    "Action" => "cloudfront:ListCloudFrontOriginAccessIdentities",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/get-cloud-front-origin-access-identity.html
# Can't do this one if the above one doesn't work
def cloudfront_get_cloud_front_origin_access_identity(identity_id:) 
  {
    "Effect" => "Allow",
    "Action" => "cloudfront:GetCloudFrontOriginAccessIdentity",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/get-cloud-front-origin-access-identity-config.html
def cloudfront_get_cloud_front_origin_access_identity_config(identity_id:)
  {
    "Effect" => "Allow",
    "Action" => "cloudfront:GetCloudFrontOriginAccessIdentityConfig",
    "Resource" => "*"
}
end
  
# ------
end; end