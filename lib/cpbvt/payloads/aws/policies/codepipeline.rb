module Cpbvt::Payloads::Aws::Policies::Codepipeline
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codepipeline/list-pipelines.html
def codepipeline_list_pipelines
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codepipeline/get-pipeline.html
def codepipeline_get_pipeline(pipeline_name:)
end

# ------
end; end