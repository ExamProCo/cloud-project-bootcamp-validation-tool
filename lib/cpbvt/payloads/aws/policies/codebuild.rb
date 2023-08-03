module Cpbvt::Payloads::Aws::Policies::Codebuild
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def codebuild_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "codebuild:ListProjects",
      "codebuild:ListBuilds",
      "codebuild:BatchGetProjects"
    ],
    "Resource" => "*"
  }
end


# ------
end; end