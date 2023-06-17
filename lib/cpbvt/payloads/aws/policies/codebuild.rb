module Cpbvt::Payloads::Aws::Policies::Codebuild
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-projects.html
def codebuild_list_projects
  {
    "Effect": "Allow",
    "Action": "codebuild:ListProjects",
    "Resource": "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-builds.html
def codebuild_list_builds
  {
    "Effect" => "Allow",
    "Action" => "codebuild:ListBuilds",
    "Resource" => "*"
}
end

def codebuild_batch_get_projects
  {
    "Effect" => "Allow",
    "Action" => "codebuild:BatchGetProjects",
    "Resource" => "*"
}
end

# ------
end; end