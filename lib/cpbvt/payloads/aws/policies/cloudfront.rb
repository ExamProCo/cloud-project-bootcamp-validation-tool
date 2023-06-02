module Cpbvt::Payloads::Aws::Policies::Cloudfront
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/list-distributions.html
def cloudfront_list_distributions
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/get-distribution.html
def cloudfront_get_distribution(distribution_id:)
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/list-invalidations.html
def cloudfront_list_invalidations(distribution_id:)
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/list-cloud-front-origin-access-identities.html
def cloudfront_list_cloud_front_origin_access_identities
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/get-cloud-front-origin-access-identity.html
# Can't do this one if the above one doesn't work
def cloudfront_get_cloud_front_origin_access_identity(identity_id:) 
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/get-cloud-front-origin-access-identity-config.html
def cloudfront_get_cloud_front_origin_access_identity_config(identity_id:)
end
  
# ------
end; end