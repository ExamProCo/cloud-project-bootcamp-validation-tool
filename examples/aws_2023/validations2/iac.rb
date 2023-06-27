Cpbvt::Tester::Runner.describe :iac do
  stacks = %w(
    CrdMachinueUser
    CrdSrvBackendFlask
    CrdSyncRole
    CrdFrontend
    CrdCicd
    CrdDb
    CrdDdb
    CrdCluster
    CrdNet
    ThumbingServerlessCdkStack
    CDKToolkit
  )
  stacks.each do |stack_name|
    spec "should_have_stack_#{stack_name.downcase}".to_sym do |t|
      status = assert_load('cloudformation-list-stacks','StackSummaries').find('StackName',stack_name).returns('StackStatus')
      statuses = %w{CREATE_COMPLETE UPDATE_COMPLETE}
      assert_include?(statuses,nil,status)
    end
  end
end