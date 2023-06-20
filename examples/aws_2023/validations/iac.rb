class Aws2023::Validations::Iac
  def self.should_have_stack(manifest:,specific_params:,stack_name:)
    data = manifest.get_output!('cloudformation-list-stacks')
    stack = data['StackSummaries'].find{|t| t['StackName'] == stack_name}
    if stack
      if %w{CREATE_COMPLETE UPDATE_COMPLETE}.include?(stack['StackStatus'])
        {result: {score: 10, message: "Found Cloudformation stack named #{name} with status UPDATE_COMPLETE or CREATE_COMPLETE"}}
      else
        {result: {score: 3, message: "Did not find Cloudformation stack named #{name} with status UPDATE_COMPLETE or CREATE_COMPLETE"}}
      end
    else
      {result: {score: 0, message: "Did not find Cloudformation stack named #{name}"}}
    end
  end

end