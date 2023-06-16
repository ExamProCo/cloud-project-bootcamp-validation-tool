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

# https://docs.aws.amazon.com/cli/latest/reference/ecs/list-services.html
def ecs_list_services(cluster_name:)
<<~COMMAND
aws ecs list-services \
--cluster #{cluster_name}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-services.html
# services is required - a list of services to describe
# can only return 10 service names
def ecs_describe_services(cluster_name:,services:)
<<~COMMAND
aws ecs describe-services \
--cluster #{cluster_name}
--services #{services.join(' ')}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecs/describe-tasks.html
def ecs_describe_tasks(cluster_name:, task_ids:)
<<~COMMAND
aws ecs describe-tasks \
--tasks #{task_ids.join(' ')} \
--cluster #{cluster_name}
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