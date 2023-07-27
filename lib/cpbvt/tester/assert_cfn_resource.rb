class Cpbvt::Tester::AssertCfnResource
  def initialize(
    describe_key:,
    spec_key:, 
    report:,
    manifest:,
    stack_name:,
    resource_type:
  )
    @describe_key = describe_key
    @spec_key = spec_key
    @report = report

    begin
      cfn_stacks = manifest.get_output!('cloudformation-list-stacks')
    rescue Errno::ENOENT
      self.fail! kind: 'assert_cfn_resource', message: 'File not found', data: {key: 'cloudformation-list-stacks'}
    rescue Errno::EACCES
      self.fail! kind: 'assert_cfn_resource', message: 'access denied', data: {key: 'cloudformation-list-stacks'}
    end # begin

    cicd_stack = cfn_stacks['StackSummaries'].find do |stack|
      stack['StackName'] == stack_name
    end
    if cicd_stack
      self.pass!(
        kind: 'assert_cfn_resource:find', 
        message: 'found value to match key',
        data: {
          key: 'StackName',
          expected_value: stack_name
      })
    else
      values = cfn_stacks['StackSummaries'].map{|t| t['StackName'] }
      self.fail!(
        kind: 'assert_cfn_resource:find', 
        message: 'failed to find value to match key',
        data: {
          key: 'StackName',
          expected_value: stack_name,
          found_values: values
      })
    end

    # extract the stack id
    cicd_stack_id = cicd_stack['StackId'].split('/').last
  
    begin
      cicd_stack_resources = manifest.get_output!("cloudformation-list-stack-resources__#{cicd_stack_id}")
    rescue Errno::ENOENT
      self.fail! kind: 'assert_cfn_resource', message: 'File not found', data: {key: "cloudformation-list-stack-resources__#{cicd_stack_id}"}
    rescue Errno::EACCES
      self.fail! kind: 'assert_cfn_resource', message: 'access denied', data: {key: "cloudformation-list-stack-resources__#{cicd_stack_id}"}
    end # begin

    @data = cicd_stack_resources['StackResourceSummaries'].find do |resource|
      resource["ResourceType"] == resource_type
    end
    if @data
      self.pass!(
        kind: 'assert_cfn_resource:find', 
        message: 'found value to match key',
        data: {
          key: 'ResourceType',
          expected_value: resource_type
      })
    else
      values = cicd_stack_resources['StackResourceSummaries'].map{|t| t['ResourceType'] }
      self.fail!(
        kind: 'assert_cfn_resource:find', 
        message: 'failed to find value to match key',
        data: {
          key: 'ResourceType',
          expected_value: resource_type,
          found_values: values
      })
    end
  end

  def returns key
    data = @data
    if key == :all || key.nil?
      self.pass! kind: 'asset_cfn_resource:returns', message: 'return all data'
      return data 
    end
    if data.key?(key)
      self.pass! kind: 'asset_cfn_resource:returns', message: 'return all data with provided key', data: { 
        provided_key: key 
      }
      return data[key]
    else
      self.fail! kind: 'asset_cfn_resource:returns', message: 'failed to return data with provided key since key does not exist', data: {
        provided_key: key 
      }
    end
  end

  def pass! kind:, message:, data: {}
    @report.pass!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: kind,
      message: message,
      data: data
    )
  end

  def fail! kind:, message:, data: {}
    @report.fail!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: kind,
      message: message,
      data: data
    )
  end
end