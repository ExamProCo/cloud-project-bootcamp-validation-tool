module Cpbvt::Payloads::Aws::Policies::Codebuild
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-projects.html
def codebuild_list_projects
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-builds.html
def codebuild_list_builds
end

# ------
end; end