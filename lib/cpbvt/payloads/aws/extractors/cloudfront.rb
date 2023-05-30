module Cpbvt::Payloads::Aws::Extractors::Cloudfront
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudfront_list_distributions_extract_distribution_ids(data)
  data['DistributionList']['Items'].map do |d|
    {
      iter_id: d['Id'],
      distribution_id: d['Id']
    }
  end
end

# ------
end; end