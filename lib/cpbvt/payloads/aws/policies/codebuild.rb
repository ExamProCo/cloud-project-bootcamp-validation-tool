module Cpbvt::Payloads::Aws::Policies::Codebuild
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-projects.html
def codebuild_list_projects(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "codebuild:ListProjects",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-builds.html
def codebuild_list_builds(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "codebuild:ListBuilds",
    "Resource" => "*"
}
end

def codebuild_batch_get_projects(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "codebuild:BatchGetProjects",
    "Resource" => "*"
}
end

# ------
end; end