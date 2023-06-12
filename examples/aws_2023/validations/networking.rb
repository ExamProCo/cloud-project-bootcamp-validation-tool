class Aws2023::Validations::Networking
  def self.should_have_custom_vpc(manifest:,specific_params:)
    data =  manifest.get_output!('ec2_describe_vpcs')

    # return back only the custom vpcs
    vpcs = data['Vpcs'].select do |vpc|
      # we assume that if its not default than its custom
      # it should be avaliable, otherwise it can't actually be working
      # we only care about resources that have the tag cruddur-networking
      vpc['IsDefault'] == false &&
      vpc['State'] == 'available' &&
      vpc['Tags'].any? do |tag|
        tag['Key'] == 'group'
        tag['Value'] == 'cruddur-networking'
      end
    end

    # We would prefer if there is only once custom vpc
    if vpcs.count == 1
      vpc = vpcs.first
      # did it have the name we expected?
      expected_vpc_name = vpc['Tags'].any? do |tag| 
        tag['Key'] == 'Name'
        tag['Value'] == 'CrdNetVPC'
      end

      # was it provisioned with Cloudformation?
      expected_cfn_stack = vpc['Tags'].any? do |tag| 
        tag['Key'] == 'aws:cloudformation:stack-name'
        # We
        #tag['Value'] == 'CrdNet'
      end

      score = 5
      message =  "Found a custom VPCs [non default VPC] that is avaliable."
      if expected_vpc_name
        score += 2
        message += " Has the expected name CrdNet."
      end
      if expected_cfn_stack
        score += 3
        message += " Provisioned with Cloudformation."
      end
      {result: {score: score, message: message},vpc_id: vpc['VpcId']}
    elsif vpcs.count > 1
      # Partial marks if we find multiple even though we expect 1.
      {result: {score: 0, message: "Found multiple custom VPCs [non default VPC] that are avaliable. Uncertain which is the correct one."}, vpc_id: false}
    else
      {result: {score: 0, message: "Failed to find any custom VPC [non default VPC] that is avaliable tagged with group:cruddur-networking"}, vpc_id: false}
    end
  end

  def self.should_have_three_public_subnets(manifest:,specific_params:,vpc_id:)
    data = manifest.get_output!('ec2_describe_subnets')

    # Subnet should be avaliable
    # Subnet should have a tag of group:cruddur-networking
    # If its has MapPublicIpOnLaunch then we'll consider it a public subnet
    subnets = data['Subnets'].select do |subnet|
      expected_tag = subnet.key?('Tags') && subnet['Tags'].any? do |tag|
        tag['Key'] == 'group'
        tag['Value'] == 'cruddur-networking'
      end

      expected_tag &&
      subnet['State'] == 'available' &&
      subnet['MapPublicIpOnLaunch'] == true
    end

    if subnets.size == 3
      {
        result: {score: 10, message: "Found 3 public subnets for VPC #{vpc_id} tagged with group:cruddur-networking"},
        public_subnet_id_1: subnets[0]['SubnetId'],
        public_subnet_id_2: subnets[1]['SubnetId'],
        public_subnet_id_3: subnets[2]['SubnetId']
      }
    else
      {
        result: {score: 0, message: "Found #{subnets.size} public subnets for VPC #{vpc_id} tagged with group:cruddur-networking but expected only 3"},
        public_subnet_id_1: false,
        public_subnet_id_2: false,
        public_subnet_id_3: false
      }
    end
    

  end

  def self.should_have_an_igw(manifest:,specific_params:,vpc_id:)
    data = manifest.get_output!('ec2_describe_internet_gateways')

    igw = data['InternetGateways'].find do |igw|
      igw['Attachments'].any? do |attachment|
        attachment['State'] == 'avaliable' &&
        attachment['VpcId'] == vpc_id
      end
      igw['Tags'].any? do |tag|
        tag['Key'] == 'group'
        tag['Value'] == 'cruddur-networking'
      end
    end

    if igw
      {result: {score: 10, message: "Found an IGW attached to the vpc: #{vpc_id} tagged with group:cruddur-networking"},igw_id: igw['InternetGatewayId']}
    else
      {result: {score: 0, message: "Failed to find an IGW attached to the vpc: #{vpc_id} tagged with group:cruddur-networking"},igw_id: false}
    end
  end

  def self.should_have_a_route_to_internet(manifest:,specific_params:,vpc_id:,igw_id:)
    data = manifest.get_output!('ec2_describe_route_tables')

    route_table = data['RouteTables'].find do |route_table|
      expected_tag = route_table['Tags'].any? do |tag|
        tag['Key'] == 'group'
        tag['Value'] == 'cruddur-networking'
      end 
      expected_route = route_table['Routes'].any? do |route|
        route['GatewayId'] == igw_id &&
        route['DestinationCidrBlock'] == '0.0.0.0/0'
      end
      expected_tag &&
      expected_route &&
      route_table['VpcId'] = vpc_id
    end

    if route_table
      {result: {score: 10, message: "Found a route table for vpc: #{vpc_id} that routes out to the internet"}}
    else
      {result: {score: 0, message: "failed to find a route table for vpc: #{vpc_id} that routes out to the internet"}}
    end
  end
end