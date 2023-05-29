module Cpbvt::Payloads::Aws::CommandsModules::Ecs
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-clusters.html
def ecs_describe_clusters
<<~COMMAND
aws ecs describe-clusters
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-services.html
# services is required - a list of services to describe
def ecs_describe_services(services:)
<<~COMMAND
aws ecs describe-services \
--services #{services}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-tasks.html
def ecs_describe_tasks(cluster:, tasks:)
<<~COMMAND
aws ecs describe-tasks \
--tasks #{tasks} \
--cluster #{cluster}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-tasks.html
def ecs_list_tasks(cluster:, family:)
<<~COMMAND
aws ecs list-tasks \
--cluster #{cluster} \
--family #{family}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-task-definitions.html
def ecs_list_task_definitions
<<~COMMAND
aws ecs list-task-definitions
COMMAND
end

# ------
end; end