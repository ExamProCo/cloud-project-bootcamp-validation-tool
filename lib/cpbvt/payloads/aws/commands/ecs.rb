module Cpbvt::Payloads::Aws::Commands::Ecs
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-clusters.html
def ecs_describe_clusters(cluster_name:)
<<~COMMAND
aws ecs describe-clusters \
--clusters #{cluster_name}
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
def ecs_describe_tasks(cluster_name:, task_id:)
<<~COMMAND
aws ecs describe-tasks \
--tasks #{task_ids} \
--cluster #{cluster}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/list-tasks.html
def ecs_list_tasks(cluster_name:, family:)
<<~COMMAND
aws ecs list-tasks \
--cluster #{cluster_name} \
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