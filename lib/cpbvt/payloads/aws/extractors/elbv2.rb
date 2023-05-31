module Cpbvt::Payloads::Aws::Extractors::Elbv2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def elbv2_describe_load_balancers__load_balancer_arn data
  data['LoadBalancers'].map do |t|
    arn = t['LoadBalancerArn']
    iter_id = arn.split('/').last
    {
      iter_id: iter_id,
      load_balancer_arn: arn
    }
  end
end

# ------
end; end