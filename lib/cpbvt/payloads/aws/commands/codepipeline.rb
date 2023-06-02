module Cpbvt::Payloads::Aws::Commands::Codepipeline
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codepipeline/list-pipelines.html
def codepipeline_list_pipelines
<<~COMMAND
aws codepipeline list-pipelines
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codepipeline/get-pipeline.html
def codepipeline_get_pipeline(pipeline_name:)
<<~COMMAND
aws codepipeline get-pipeline \
--name #{pipeline_name}
COMMAND
end

# ------
end; end