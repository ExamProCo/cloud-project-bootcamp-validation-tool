class Aws2023::Validations::Db
  def self.should_have_public_rds_instance(manifest:,specific_params:,vpc_id:)
    resource_cluster = Cpbvt::Payloads::Aws::Extractor.cloudformation_list_stacks__by_stack_resource_type(
      manifest,
      'CrdDb',
      "WS::RDS::DBInstance"
    )
    db_id = resource_cluster['PhysicalResourceId']

    data = manifest.get_output!('rds-describe-db-instances')

    db =
    data['DbInstances'].find do |t|
      t['DBInstanceIdentifier'] == db_id
    end

    found =
    db['PubliclyAccessible'] = true &&
    db['Engine'] = 'postgres' &&
    db['DBSubnetGroup']['VpcId'] == vpc_id

    if found

    else

    end
  end

  def self.should_have_db_sg(manifest:,specific_params:)

    sg_data = manifest.get_output!('ec2-describe-security-groups')
    sg = sg_data['SecurityGroups'].find{|t| t['GroupId'] == sg_id}

    serv_sg_rule =
    sg['IpPermissions'].find do |rule|
      rule['FromPort'] == 5432 &&
      rule['ToPort'] == 5432 &&
      rule['UserIdGroupPairs'].first['GroupId'] == serv_sg_id
    end
  end
end