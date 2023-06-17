module Cpbvt::Payloads::Aws::Policies::Codepipeline
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codepipeline/list-pipelines.html
def codepipeline_list_pipelines(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "codepipeline:ListPipelines",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codepipeline/get-pipeline.html
def codepipeline_get_pipeline(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "codepipeline:GetPipeline",
    "Resource" => "*"
  }
end

# ------
end; end