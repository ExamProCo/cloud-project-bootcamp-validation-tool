Cpbvt::Tester::Runner.describe :networking do |t|
  spec :should_have_custom_vpc do |t|
    vpcs = assert_load('ec2_describe_vpcs','Vpcs').returns(:all)

    vpc = 
    assert_find(vpcs) do |assert, vpc|
      assert.expects_false(vpc,'IsDefault')
      assert.expects_eq(vpc,'State','available')
      assert.expects_any?(vpc,'Tags', label: "Tags:group:cruddur-networking") do |tag|
        tag['Key'] == 'group' &&
        tag['Value'] == 'cruddur-networking'
      end
      assert.expects_any?(vpc,'Tags', label: "aws:cloudformation:stack-name") do |tag|
        tag['Key'] == 'aws:cloudformation:stack-name'
      end
    end.returns(:all)

    set_pass_message "Found multiple custom VPCs [non default VPC] that are avaliable. Uncertain which is the correct one."
    set_fail_message "Failed to find any custom VPC [non default VPC] that is avaliable tagged with group:cruddur-networking"

    vpc_id = false if vpc_id.nil?

    set_state_value :vpc_id, vpc_id
  end
end