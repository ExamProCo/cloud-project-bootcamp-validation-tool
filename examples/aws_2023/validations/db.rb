class Aws2023::Validations::Db
  def self.should_have_public_rds_instance(manifest:,specific_params:,vpc_id:)
    resource_cluster = Cpbvt::Payloads::Aws::Extractor.cloudformation_list_stacks__by_stack_resource_type(
      manifest,
      'CrdDb',
      "AWS::RDS::DBInstance"
    )
    db_id = resource_cluster['PhysicalResourceId']

    data = manifest.get_output!('rds-describe-db-instances')

    db =
    data['DBInstances'].find do |t|
      t['DBInstanceIdentifier'] == db_id
    end

    found =
    db['PubliclyAccessible'] = true &&
    db['Engine'] = 'postgres' &&
    db['DBSubnetGroup']['VpcId'] == vpc_id

    if found
      {result: {score: 10, message: "Found the primary database running an RDS instance of postgres"}}
    else
      {result: {score: 10, message: "Failed to find the primary database running an RDS instance of postgres"}}
    end
  end

  def self.should_have_db_sg(manifest:,specific_params:,serv_sg_id:)
    resource_cluster = Cpbvt::Payloads::Aws::Extractor.cloudformation_list_stacks__by_stack_resource_type(
      manifest,
      'CrdDb',
      "AWS::EC2::SecurityGroup"
    )
    sg_id = resource_cluster['PhysicalResourceId']

    sg_data = manifest.get_output!('ec2-describe-security-groups')
    sg = sg_data['SecurityGroups'].find{|t| t['GroupId'] == sg_id}

    serv_sg_rule =
    sg['IpPermissions'].find do |rule|
      rule['FromPort'] == 5432 &&
      rule['ToPort'] == 5432 &&
      rule['UserIdGroupPairs'].any?{|t|t['GroupId'] == serv_sg_id}
    end

    if serv_sg_rule
      {result: {score: 10, message: "Found a Security Group for the RDS Instance with ingress allowed on port 4567 for the backend-service SG"}} 
    else
      {result: {score: 0, message: "Failed to find a Security Group for the RDS Instance with ingress allowed on port 4567 for the backend-service SG"}} 
    end
  end
end