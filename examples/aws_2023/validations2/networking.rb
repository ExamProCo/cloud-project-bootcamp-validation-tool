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
    data = assert_load('ec2_describe_subnets','Subnets').returns(:all)

    subnets =
    assert_select(data) do |assert, subnet|
      assert.expects_any?(subnet,'Tags', label: "Tags:group:cruddur-networking") do |tag|
        tag['Key'] == 'group' &&
        tag['Value'] == 'cruddur-networking'
      end
      assert.expects_eq(subnet,'State','available')
      assert.expects_true(subnet,'MapPublicIpOnLaunch')
    end.returns(:all)
  end

  spec :should_have_an_igw do |t|
    vpc_id = t.dynamic_params.vpc_id

    igws = assert_load('ec2_describe_internet_gateways','InternetGateways').returns(:all)

    igw_id =
    assert_find(igws) do |assert, igw|
      assert.expects_any?(igw,'Tags', label: "Tags:group:cruddur-networking") do |tag|
        tag['Key'] == 'group' &&
        tag['Value'] == 'cruddur-networking'
      end
      assert.expects_any?(igw,'Attachments',label: "State:available,vpcid:#{vpc_id}") do |attachment|
        attachment['State'] == 'available' &&
        attachment['VpcId'] == vpc_id
      end
    end.returns('InternetGatewayId') #assert_find

    set_pass_message "Found an IGW attached to the vpc: #{vpc_id} tagged with group:cruddur-networking"
    set_fail_message "Failed to find an IGW attached to the vpc: #{vpc_id} tagged with group:cruddur-networking"

    igw_id = false if igw_id.nil?

    set_state_value :igw_id, igw_id
  end # spec

   spec :should_have_a_route_to_internet do |t|
    igw_id = t.dynamic_params.igw_id
    vpc_id = t.dynamic_params.vpc_id

    route_tables = assert_load('ec2_describe_route_tables','RouteTables').returns(:all)

    route_table =
    assert_find(route_tables) do |assert, route_table|
      assert.expects_any?(route_table,'Tags', label: "Tags:group:cruddur-networking") do |tag|
        tag['Key'] == 'group' &&
        tag['Value'] == 'cruddur-networking'
      end
      assert.expects_any?(route_table,'Routes',label: "GatewayId:#{igw_id},DestinationCidrBlock:0.0.0.0/0") do |route|
        route['GatewayId'] == igw_id &&
        route['DestinationCidrBlock'] == '0.0.0.0/0'
      end
      assert.expects_eq(route_table,'VpcId',vpc_id)
    end.returns(:all) #assert_find

    assert_not_nil(route_table, label: 'Route table not nil')

    set_pass_message "Found a route table for vpc: #{vpc_id} that routes out to the internet"
    set_fail_message "Failed to find a route table for vpc: #{vpc_id} that routes out to the internet"
   end
end