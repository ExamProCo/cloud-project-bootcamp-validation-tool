module Cpbvt::Payloads::Aws::Policies::Route53
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/route53/list-hosted-zones.html
def route53_list_hosted_zones
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/route53/get-hosted-zone.html
def route53_get_hosted_zone(hosted_zone_id:)
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/route53/list-resource-record-sets.html
def route53_list_resource_record_sets(hosted_zone_id:)
end

# ------
end; end