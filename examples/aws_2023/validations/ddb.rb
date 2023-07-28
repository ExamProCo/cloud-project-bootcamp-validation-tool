Cpbvt::Tester::Runner.describe :ddb do
  spec :should_have_ddb_table do |t|
    stack_name_ddb = t.specific_params.cfn_stack_name_ddb
    table_name = assert_cfn_resource(stack_name_ddb,"AWS::DynamoDB::Table").returns('PhysicalResourceId')
    table = assert_load("dynamodb-describe-table__#{table_name}",'Table').returns(:all)

    key_schema = assert_json(table,'KeySchema').returns(:all)

    pk =
    assert_find(key_schema) do |assert,item|
      assert.expects_eq(item,'AttributeName','pk')
      assert.expects_eq(item,'KeyType','HASH')
    end.returns(:all)

    sk =
    assert_find(key_schema) do |assert,item|
      assert.expects_eq(item,'AttributeName','sk')
      assert.expects_eq(item,'KeyType','RANGE')
    end.returns(:all)

    assert_not_nil(pk)
    assert_not_nil(sk)

    assert_json(table,'TableStatus').expects_eq('ACTIVE')
    assert_json(table,'TableSizeBytes').expects_gt(0)
    assert_json(table,'ItemCount').expects_gt(0)

    set_pass_message "Found dynamodb table with data in it"
    set_fail_message "Failed to find dynamodb table with data in it"
  end

  spec :should_have_gsi do |t|
    table_name = assert_cfn_resource(t.specific_params.cfn_stack_name_ddb,"AWS::DynamoDB::Table").returns('PhysicalResourceId')
    table = assert_load("dynamodb-describe-table__#{table_name}",'Table').returns(:all)

    gsi = assert_json(table,'GlobalSecondaryIndexes').returns(:first)
    key_schema = assert_json(gsi,'KeySchema').returns(:all)

    pk =
    assert_find(key_schema) do |assert,item|
      assert.expects_eq(item,'AttributeName','message_group_uuid')
      assert.expects_eq(item,'KeyType','HASH')
    end.returns(:all)

    sk =
    assert_find(key_schema) do |assert,item|
      assert.expects_eq(item,'AttributeName','sk')
      assert.expects_eq(item,'KeyType','RANGE')
    end.returns(:all)

    assert_not_nil(pk)
    assert_not_nil(sk)

    assert_json(gsi,'IndexStatus').expects_eq('ACTIVE')
    assert_json(gsi,'TableSizeBytes').expects_gt(0)
    assert_json(gsi,'ItemCount').expects_gt(0)

    set_pass_message "Found dynamodb table GSI with data in it"
    set_fail_message "Failed to find dynamodb table GSI with data in it"
  end

  spec :should_have_ddb_stream do |t|
    table_name = assert_cfn_resource(t.specific_params.cfn_stack_name_ddb,"AWS::DynamoDB::Table").returns('PhysicalResourceId')
    table = assert_load("dynamodb-describe-table__#{table_name}",'Table').returns(:all)

    label = assert_json(table,'LatestStreamLabel').returns(:all)

    desc = assert_load("dynamodbstreams-describe-stream__#{label}").returns('StreamDescription')

    assert_json(desc,'StreamStatus').expects_eq('ENABLED')
    assert_json(desc,'StreamViewType').expects_eq('NEW_IMAGE')

    set_pass_message "Found dynamodb stream with NEW_IMAGE"
    set_fail_message "Failed to find dynamodb stream with NEW_IMAGE"
  end
end