module Cpbvt::Payloads::Aws::Extractors::Codepipeline
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def codepipeline_list_pipelines__pipeline_name data
  data['pipelines'].map do |t|
    {
      iter_id: t['name'],
      pipeline_name: t['name']
    }
  end
end

# ------
end; end