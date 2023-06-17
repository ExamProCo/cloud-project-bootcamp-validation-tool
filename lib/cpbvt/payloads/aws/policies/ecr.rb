module Cpbvt::Payloads::Aws::Policies::Ecr
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecr/describe-repositories.html
def ecr_describe_repositories
  {
    "Effect" => "Allow",
    "Action" => "ecr:DescribeRepositories",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecr/describe-images.html
def ecr_describe_images(repository_name:)
  {
    "Effect" => "Allow",
    "Action" => "ecr:DescribeImages",
    "Resource" => "*"
  }
end

# ------
end; end