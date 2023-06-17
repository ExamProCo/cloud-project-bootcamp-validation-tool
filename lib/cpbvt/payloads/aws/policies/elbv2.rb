module Cpbvt::Payloads::Aws::Policies::Elbv2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-load-balancers.html
def elbv2_describe_load_balancers
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeLoadBalancers",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-listeners.html
def elbv2_describe_listeners
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeListeners",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-load-balancer-attributes.html
def elbv2_describe_load_balancer_attributes
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeLoadBalancerAttributes",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-rules.html
def elbv2_describe_rules
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeRules",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-target-groups.html
def elbv2_describe_target_groups
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeTargetGroups",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-target-group-attributes.html
def elbv2_describe_target_group_attributes(target_group_arn:) 
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeTargetGroupAttributes",
    "Resource" => "*"
}
end

# ------
end; end