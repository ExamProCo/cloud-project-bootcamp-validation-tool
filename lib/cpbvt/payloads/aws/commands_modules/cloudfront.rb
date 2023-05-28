module Cpbvt::Payloads::Aws::CommandsModules::Cloudfront
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudfront_list_distributions(output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cloudfront list-distributions \
--output json > #{output_file}
COMMAND
end

def cloudfront_get_distribution(output_file:, distribution_id:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cloudfront get-distribution \
--id #{distribution_id} \
--output json > #{output_file}
COMMAND
end

def cloudfront_list_invalidations(output_file:, distribution_id:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cloudfront list-invalidations  \
--id #{distribution_id} \
--output json > #{output_file}
COMMAND
end

def cloudfront_list_cloud_front_origin_access_identities(output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cloudfront list-cloud-front-origin-access-identities \
--output json > #{output_file}
COMMAND
end
# get-cloud-front-origin-access-identity
def cloudfront_get_cloud_front_origin_access_identity(output_file:, identity_id:) 
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cloudfront get-cloud-front-origin-access-identity \
--id #{identity_id} \
--output json > #{output_file}
COMMAND
end

# get-cloud-front-origin-access-identity-config
def cloudfront_get_cloud_front_origin_access_identity_config(output_file:, identity_id:)
   command = <<~COMMAND.strip.gsub("\n", " ")
aws cloudfront get-cloud-front-origin-access-identity-config \
--id #{identity_id} \
--output json > #{output_file}
COMMAND
end
  
# ------
end; end