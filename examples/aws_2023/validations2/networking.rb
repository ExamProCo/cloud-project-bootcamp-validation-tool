Cpbvt::Tester::Runner.describe :networking do |t|
  spec :should_have_custom_vpc do |t|
    vpcs = assert_load('ec2_describe_vpcs','Vpcs').returns(:all)

    vpc_id = 
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
    end.returns('VpcId')

    set_pass_message "Found multiple custom VPCs [non default VPC] that are avaliable. Uncertain which is the correct one."
    set_fail_message "Failed to find any custom VPC [non default VPC] that is avaliable tagged with group:cruddur-networking"

    vpc_id = false if vpc_id.nil?

    set_state_value :vpc_id, vpc_id
  end

  spec :should_have_three_public_subnets do |t|
    data = assert_load('ec2_describe_subnets','Subnets')
    # TODO - find a certain amount
  end

  spec :should_have_an_igw do |t|
    vpc_id = t.dynamic_params.vpc_id

    igws = assert_load('ec2_describe_internet_gateways','InternetGateways').returns(:all)

    igw_id =
    assert_find(igws) do |assert, vpc|
      assert.expects_any?(vpc,'Tags', label: "Tags:group:cruddur-networking") do |tag|
        tag['Key'] == 'group' &&
        tag['Value'] == 'cruddur-networking'
      end
      assert.expects_any?(vpc,'Attachments') do |attachment|
        attachment['State'] == 'avaliable' &&
        attachment['VpcId'] == vpc_id
      end
    end.returns('InternetGatewayId') #assert_find
    binding.pry

    set_pass_message "Found an IGW attached to the vpc: #{vpc_id} tagged with group:cruddur-networking"
    set_fail_message "Failed to find an IGW attached to the vpc: #{vpc_id} tagged with group:cruddur-networking"

    binding.pry
    set_state_value :igw_id, igw_id
  end # spec
end