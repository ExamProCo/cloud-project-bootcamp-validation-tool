module Cpbvt::Payloads::Aws::Extractors::Elbv2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def elbv2_describe_load_balancers__load_balancer_arn data, filters={}
  data['LoadBalancers'].map do |t|
    arn = t['LoadBalancerArn']
    iter_id = arn.split('/').last
    {
      iter_id: iter_id,
      load_balancer_arn: arn
    }
  end
end

def elbv2_describe_target_groups__target_group_arn data, filters={}
  data['TargetGroups'].map do |t|
    arn = t['TargetGroupArn']
    iter_id = arn.split('/').last
    {
      iter_id: iter_id,
      target_group_arn: arn
    }
  end
end
# ------
end; end