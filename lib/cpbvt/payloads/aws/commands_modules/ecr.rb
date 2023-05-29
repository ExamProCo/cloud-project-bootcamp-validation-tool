module Cpbvt::Payloads::Aws::CommandsModules::Ecr
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecr/describe-repositories.html
def ecr_describe_repositories
<<~COMMAND
aws ecr describe-repositories
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecr/describe-images.html
def ecr_describe_images(repository_name:)
<<~COMMAND
aws ecr describe-images \
--repository-name #{repository_name} 
COMMAND
end

# ------
end; end