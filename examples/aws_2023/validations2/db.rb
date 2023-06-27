Cpbvt::Tester::Runner.describe :db do
  spec :should_have_public_rds_instance do |t|
    vpc_id = t.dynamic_params.vpc_id

    db_id = assert_cfn_resource('CrdDb',"AWS::RDS::DBInstance").returns('PhysicalResourceId')
    db = assert_load('rds-describe-db-instances','DBInstances').find('DBInstanceIdentifier',db_id).returns(:all)

    assert_json(db,'PubliclyAccessible').expects_true
    assert_json(db,'Engine').expects_eq('postgres')
    assert_json(db,'DBSubnetGroup','VpcId').expects_eq(vpc_id)

    set_pass_message "Found the primary database running an RDS instance of postgres"
    set_fail_message "Failed to find the primary database running an RDS instance of postgres"
  end

  spec :should_have_db_sg do |t|
    serv_sg_id = t.dynamic_params.serv_sg_id

    sg_id = assert_cfn_resource('CrdDb',"AWS::EC2::SecurityGroup").returns('PhysicalResourceId')

    sg = assert_load('ec2-describe-security-groups','SecurityGroups').find('GroupId',sg_id).returns(:all)

    rules = assert_json(sg,'IpPermissions').returns(:all)

    serv_sg_rule =
    assert_find(rules) do |assert,rule|
      assert.expects_eq(rule,'FromPort',5432)
      assert.expects_eq(rule,'ToPort',5432)
      assert.expects_any?(rule,'UserIdGroupPairs') do |pair|
        pair['GroupId'] == serv_sg_id
      end
    end.returns(:all)

    assert_not_nil(serv_sg_rule)

    set_pass_message "Found a Security Group for the RDS Instance with ingress allowed on port 4567 for the backend-service SG"
    set_fail_message "Failed to find a Security Group for the RDS Instance with ingress allowed on port 4567 for the backend-service SG"
  end
end