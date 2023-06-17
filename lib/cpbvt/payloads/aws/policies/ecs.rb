module Cpbvt::Payloads::Aws::Policies::Ecs
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-clusters.html
def ecs_describe_clusters
  {
    "Effect" => "Allow",
    "Action" => "ecs:DescribeClusters",
    "Resource" => "*"
}
end

def ecs_list_services
  {
    "Effect" => "Allow",
    "Action" => "ecs:ListServices",
    "Resource" => "*"
  }
end
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-services.html
# services is required - a list of services to describe
def ecs_describe_services
  {
    "Effect" => "Allow",
    "Action" => "ecs:DescribeServices",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-tasks.html
def ecs_describe_tasks
  {
    "Effect": "Allow",
    "Action": "ecs:DescribeTasks",
    "Resource": "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-tasks.html
def ecs_list_tasks
  {
    "Effect" => "Allow",
    "Action" => "ecs:ListTasks",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-task-definitions.html
def ecs_list_task_definitions
  {
    "Effect" => "Allow",
    "Action" => "ecs:ListTaskDefinitions",
    "Resource" => "*"
  }
end

# ------
end; end