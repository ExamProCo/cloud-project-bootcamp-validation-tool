module Cpbvt::Payloads::Aws::Policies::Ecs
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-clusters.html
def ecs_describe_clusters
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-services.html
# services is required - a list of services to describe
def ecs_describe_services(services:)
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-tasks.html
def ecs_describe_tasks(cluster:, tasks:)
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-tasks.html
def ecs_list_tasks(cluster:, family:)
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-task-definitions.html
def ecs_list_task_definitions
end

# ------
end; end