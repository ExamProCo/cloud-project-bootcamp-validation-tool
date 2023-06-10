module Cpbvt::Payloads::Aws::Extractors::Cloudformation
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudformation_list_stacks__stack_name(data,filters={})
  data['StackSummaries'].map do |x| 
    arn     = x['StackId'] 
    iter_id = arn.split("/").last
    {
      iter_id: iter_id,
      stack_name: x['StackName']
    }
  end
end

# ------
end; end