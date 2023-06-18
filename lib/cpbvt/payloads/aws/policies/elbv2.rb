module Cpbvt::Payloads::Aws::Policies::Elbv2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-load-balancers.html
def elbv2_describe_load_balancers(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeLoadBalancers",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-listeners.html
def elbv2_describe_listeners(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeListeners",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-load-balancer-attributes.html
def elbv2_describe_load_balancer_attributes(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeLoadBalancerAttributes",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-rules.html
def elbv2_describe_rules(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeRules",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-target-groups.html
def elbv2_describe_target_groups(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeTargetGroups",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/describe-target-group-attributes.html
def elbv2_describe_target_group_attributes(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "elasticloadbalancing:DescribeTargetGroupAttributes",
    "Resource" => "*"
}
end

def elbv2_describe_target_health(aws_account_id:,region:)
  {
    "Effect": "Allow",
    "Action": [
        "elasticloadbalancing:DescribeTargetHealth",
        "elasticloadbalancing:DescribeLoadBalancerAttributes"
    ],
    "Resource": "*"
  }
end
# ------
end; end