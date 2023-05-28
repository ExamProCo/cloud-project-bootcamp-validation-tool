module Cpbvt::Payloads::Aws::CommandsModules::Codebuild
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def codebuild_list_projects(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws codebuild list-projects \ 
--region #{region} --output json > #{output_file}
COMMAND
end

# codebuild_list Builds
def codebuild_list_builds(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws codebuild list-builds \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end