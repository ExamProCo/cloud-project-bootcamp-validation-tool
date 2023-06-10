module Cpbvt::Payloads::Aws::Extractors::Cloudfront
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudfront_list_distributions__distribution_id(data,filters={})
  data['DistributionList']['Items'].map do |d|
    # by default return the result
    result = true

    if filters.key?(:aliases) && filters.key?(:aliases).any?
      found_aliases = d['Aliases']['Items'] 
      result = found_aliases.any? do |found_alias| 
        filters[:aliases].include?(found_alias)
      end
    end

    if result
      {
        iter_id: d['Id'],
        distribution_id: d['Id']
      }
    end
  end
end

# ------
end; end