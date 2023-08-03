module Cpbvt::Payloads::Aws::Policies::Ecs
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def ecs_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "ecs:DescribeClusters",
      "ecs:ListServices",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:ListTaskDefinitions"
    ],
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-services.html
# services is required - a list of services to describe
def ecs_describe_services(aws_account_id:,region:,cluster_name:,services:[])
  resources = services.map do |name|
    "arn:aws:ecs:#{region}:#{aws_account_id}:service/#{cluster_name}/#{name}"
  end
  resources = "*" if resources.empty?
  {
    "Effect" => "Allow",
    "Action" => "ecs:DescribeServices",
    "Resource" => resources
  }
end

# ------
end; end