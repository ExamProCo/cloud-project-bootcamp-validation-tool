module Cpbvt::Payloads::Aws::Commands::Codebuild
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-projects.html
def codebuild_list_projects
<<~COMMAND
aws codebuild list-projects
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-builds.html
def codebuild_list_builds
<<~COMMAND
aws codebuild list-builds
COMMAND
end

# ------
end; end