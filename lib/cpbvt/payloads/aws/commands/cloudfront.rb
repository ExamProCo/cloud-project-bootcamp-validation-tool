module Cpbvt::Payloads::Aws::Commands::Cloudfront
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/list-distributions.html
def cloudfront_list_distributions
<<~COMMAND
aws cloudfront list-distributions
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/get-distribution.html
def cloudfront_get_distribution(distribution_id:)
<<~COMMAND
aws cloudfront get-distribution \
--id #{distribution_id}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/list-invalidations.html
def cloudfront_list_invalidations(distribution_id:)
 <<~COMMAND
aws cloudfront list-invalidations \
--distribution-id #{distribution_id}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/list-cloud-front-origin-access-identities.html
# This returns blank and I don't know why....
def cloudfront_list_cloud_front_origin_access_identities
<<~COMMAND
aws cloudfront list-cloud-front-origin-access-identities
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/get-cloud-front-origin-access-identity.html
# Can't do this one if the above one doesn't work
def cloudfront_get_cloud_front_origin_access_identity(identity_id:) 
<<~COMMAND
aws cloudfront get-cloud-front-origin-access-identity \
--id #{identity_id}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudfront/get-cloud-front-origin-access-identity-config.html
def cloudfront_get_cloud_front_origin_access_identity_config(identity_id:)
<<~COMMAND
aws cloudfront get-cloud-front-origin-access-identity-config \
--id #{identity_id}
COMMAND
end
  
# ------
end; end