module Cpbvt::Payloads::Aws::CommandsModules::Elbv2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-load-balancers.html
def elbv2_describe_load_balancers
<<~COMMAND
aws elbv2 describe-load-balancers
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-listeners.html
def elbv2_describe_listeners(load_balancer_arn:)
<<~COMMAND
aws elbv2 describe-listeners \
--load-balancer-arn #{load_balancer_arn}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-load-balancer-attributes.html
def elbv2_describe_load_balancer_attributes(load_balancer_arn:) 
<<~COMMAND
aws elbv2 describe-load-balancer-attributes \
--load-balancer-arn #{load_balancer_arn}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-rules.html
def elbv2_describe_rules(listern_arn:)
<<~COMMAND
aws elbv2 describe-rules \
--listener-arn #{listen_arn}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-target-groups.html
def elbv2_describe_target_groups
<<~COMMAND
aws elbv2 describe-target-groups
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-target-group-attributes.html
def elbv2_describe_target_group_attributes(target_group_arn:) 
<<~COMMAND
aws elbv2 describe-target-group-attributes \
--target-group-arn #{target_group_arn}
COMMAND
end

# ------
end; end