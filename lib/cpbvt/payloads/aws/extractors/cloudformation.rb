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

# We often need to just grab a specific resource from a stack
# based on its resource type.
def cloudformation_list_stacks__by_stack_resource_type(data,stack_name,resource_type)
  # Find the stack for CICD
  cicd_stack = data['StackSummaries'].find do |stack|
    stack['StackName'] == stack_name
  end
  # extract the stack id
  cicd_stack_id = cicd_stack['StackId'].split('/').last

  cicd_stack_resources = manifest.get_output!("cloudformation-list-stack-resources__#{cicd_stack_id}")
  stack_resource = cicd_stack_resources['StackResourceSummaries'].find do |resource|
    resource["ResourceType"] == resource_type
  end
  return stack_Resource
end

# ------
end; end