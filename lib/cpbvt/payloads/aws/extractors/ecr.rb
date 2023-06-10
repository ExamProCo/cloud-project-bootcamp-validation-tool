module Cpbvt::Payloads::Aws::Extractors::Ecr
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def ecr_describe_repositories__repository_name data, filters={}
  data['repositories'].map do |t|
    {
      iter_id: t['registryId'],
      repository_name: t['repositoryName']
    }
  end
end

# ------
end; end