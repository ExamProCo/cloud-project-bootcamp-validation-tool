Cpbvt::Tester::Runner.describe :iac do
  spec "should_have_stack_machineuser".to_sym do |t|
    stack_name = t.specific_params.cfn_stack_name_machineuser
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end

  spec "should_have_stack_backend".to_sym do |t|
    stack_name = t.specific_params.cfn_stack_name_backend
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end

  spec "should_have_stack_sync".to_sym do |t|
    stack_name = t.specific_params.cfn_stack_name_sync
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end

  spec "should_have_stack_frontend".to_sym do |t|
    stack_name = t.specific_params.cfn_stack_name_frontend
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end

  spec "should_have_stack_cicd".to_sym do |t|
    stack_name = t.specific_params.cfn_stack_name_cicd
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end

  spec "should_have_stack_db".to_sym do |t|
    stack_name = t.specific_params.cfn_stack_name_db
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end

  spec "should_have_stack_ddb".to_sym do |t|
    stack_name = t.specific_params.cfn_stack_name_ddb
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end

  spec "should_have_stack_cluster".to_sym do |t|
    stack_name = t.specific_params.cfn_stack_name_cluster
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end

  spec "should_have_stack_networking".to_sym do |t|
    stack_name = t.specific_params.cfn_stack_name_networking
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end

  spec "should_have_stack_serverless_cdk".to_sym do |t|
    stack_name = t.specific_params.cfn_stack_name_cdk
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end

  spec "should_have_stack_cdk_toolkit".to_sym do |t|
    stack_name = 'CDKToolkit'
    status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
    statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
    assert_include?(statuses,nil,status)
  end
end