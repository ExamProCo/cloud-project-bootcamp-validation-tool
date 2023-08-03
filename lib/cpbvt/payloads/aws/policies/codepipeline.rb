module Cpbvt::Payloads::Aws::Policies::Codepipeline
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def codepipeline_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "codepipeline:ListPipelines",
      "codepipeline:GetPipeline"
    ],
    "Resource" => "*"
  }
end

# ------
end; end