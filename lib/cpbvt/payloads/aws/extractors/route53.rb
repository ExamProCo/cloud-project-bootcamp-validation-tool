module Cpbvt::Payloads::Aws::Extractors::Route53
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def route53_list_hosted_zones__hosted_zone_id data, filters={}
  data['HostedZones'].map do |t|
    id = t['Id'].split("/").last
    {
      iter_id:  id,
      hosted_zone_id: id
    }
  end
end

# ------
end; end