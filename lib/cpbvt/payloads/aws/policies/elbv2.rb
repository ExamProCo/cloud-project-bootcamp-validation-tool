module Cpbvt::Payloads::Aws::Policies::Elbv2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def elbv2_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth"
    ],
    "Resource" => "*"
  }
end

# ------
end; end