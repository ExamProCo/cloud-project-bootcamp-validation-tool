module Cpbvt::Payloads::Aws::Policies::Ecr
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
def ecr_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "ecr:DescribeRepositories",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecr/describe-images.html
def ecr_describe_images(aws_account_id:,region:,repository_names:[])
  resources = repository_names.map do |repo_name| 
    "arn:aws:ecr:#{region}:#{aws_account_id}:repository/#{repo_name}"
  end
  resources = "*" if resources.empty?
  {
    "Effect" => "Allow",
    "Action" => "ecr:DescribeImages",
    "Resource" => resources
  }
end

# ------
end; end