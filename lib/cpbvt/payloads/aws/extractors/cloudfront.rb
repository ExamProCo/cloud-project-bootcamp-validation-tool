module Cpbvt::Payloads::Aws::Extractors::Cloudfront
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudfront_list_distributions__distribution_id(data,filters={})
  data['DistributionList']['Items'].filter_map do |d|
    result = true

    if filters.key?(:aliases) && filters[:aliases].any?
      if d.key?('Aliases')
        if d['Aliases'].key?('Items')
          found_aliases = d['Aliases']['Items'] 
          result = found_aliases.any? do |found_alias| 
            filters[:aliases].include?(found_alias)
          end
        else
          false
        end
      else
        false
      end
    end

    if result
      {
        iter_id: d['Id'],
        distribution_id: d['Id']
      }
    end
  end # .filter_map
end

def cloudfront_list_origin_access_controls__control_id(data,filters={})
  data['OriginAccessControlList']['Items'].map do |x|
    id = x['Id']
    iter_id = x['Id']
    {
      iter_id: iter_id,
      control_id: id
    }
  end
end

# ------
end; end
