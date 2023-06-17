module Cpbvt::Payloads::Aws::Policies::Ecs
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-clusters.html
def ecs_describe_clusters(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "ecs:DescribeClusters",
    "Resource" => "*"
}
end

def ecs_list_services(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "ecs:ListServices",
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

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-tasks.html
def ecs_describe_tasks(aws_account_id:,region:,cluster_name:)
  {
    "Effect" => "Allow",
    "Action" => "ecs:DescribeTasks",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-tasks.html
def ecs_list_tasks(aws_account_id:,region:,cluster_name:, family:)
  {
    "Effect" => "Allow",
    "Action" => "ecs:ListTasks",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-task-definitions.html
def ecs_list_task_definitions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "ecs:ListTaskDefinitions",
    "Resource" => "*"
  }
end

# ------
end; end