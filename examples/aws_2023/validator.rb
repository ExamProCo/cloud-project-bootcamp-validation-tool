class Aws2023::Validator
  def self.run(
      project_scope:,
      run_uuid:,
      user_uuid:,
      output_path:,
      region:,
      aws_access_key_id:,
      aws_secret_access_key:,
      payloads_bucket:
  )

  raise "Validator.run: run_uuid should not be null" if run_uuid.nil?
  raise "Validator.run: user_uuid should not be null" if user_uuid.nil?
  raise "Validator.run: project_scope should not be null" if project_scope.nil?
  raise "Validator.run: output_path should not be null" if output_path.nil?
  raise "Validator.run: region should not be null" if region.nil?
  raise "Validator.run: aws_access_key_id should not be null" if aws_access_key_id.nil?
  raise "Validator.run: aws_secret_access_key should not be null" if aws_secret_access_key.nil?
  raise "Validator.run: payloads_bucket should not be null" if payloads_bucket.nil?

  manifest_file =  '/workspace/cloud-project-bootcamp-validation-tool/examples/output/aws-bootcamp-2023/user-da124fec-133b-45c5-8423-04b768c886c2/run-1686187402-531bc63a-b5cd-414d-b066-c9b940f300be/manifest.json'
  manifest = Cpbvt::Manifest.new(
    user_uuid: user_uuid,
    run_uuid: run_uuid,
    output_path: output_path,
    project_scope: project_scope,
    payloads_bucket: payloads_bucket
  )
  manifest.load_from_file!
  manifest.pull!

  # Networking Validation
  result = Aws2023::Validator.should_have_custom_vpc(manifest)
  puts result
    # should have a custom vpc 
    # with 3 public subnets
    # with a IGW
    # with a route table that routes to the internet

  # CI/CD Validation
    # should have a codepipeline
    # with a source from github to the expected bootcamp repo
    # with a build step to codebuild
    # with deployment using ECS deployer

  # IaC Validation
    # should have CFN stacks named the following: <stack_names>

  # Primary Compute Validation
    # Should have an ECS cluster named <cluster_name>
      # with fargate service running named <service_name> on port 4567
        # and the service should have a security group <sg-serv-id>
          # and it should provide access to the  alb securitygroup <sg-alb-id> on port 4567

    # should have a cloud map namespace named <cloudmap_namespace>
  
  # Frontend Static Website Hosting Validation
    # should have an s3 bucket called <s3-website-bucket-name>
      # with cors?
      # with block public access turnred off?
      # with a bucket policy?
    # should have a CFN distribution

  # Primary Db Validation
    # should have an RDS instance running
    # the RDS instance should be publically avaliable
    # the RDS instance should have a security group <sg-rds-id>
    # and it should provide access to the fargate service security group <sg-serv-id> on port 5432

  # DynamoDB Validation
    # should have a dynamodb table named <db-table-name>
      # should have a dynamodbstream

  # Serverless Asset Pipeline Validation
    # should have an HTTP API Gateway
      # with an /avatar endpoint
        # with lambda authorizer
      # with a proxy endpoint
        # with lambda authorizer

  # Authenication Validation
    # should have a Cognito User Pool
      # with a trigger on post configuration

  # Domain Management?

  # Container Repo Storage?

  end # def self.run

  def self.should_have_custom_vpc manifest
    key = 'ec2_describe_vpcs'
    if manifest.has_payload?(key)
      data =  manifest.get_output(key)
    else
      raise "#{key} not found in manifest"
    end


    # return back only the custom vpcs
    vpcs = data['Vpcs'].select do |vpc|
      # we assume that if its not default than its custom
      # it should be avaliable, otherwise it can't actually be working
      vpc['IsDefault'] == false &&
      vpc['State'] == 'available' 
    end

    # We would prefer if there is only once custom vpc
    if vpcs.count == 1
      # did it have the name we expected?
      expected_vpc_name = vpcs.first['Tags'].any? do |tag| 
        tag['Key'] == 'Name'
        tag['Value'] == 'CrdNetVPC'
      end

      # was it provisioned with Cloudformation?
      expected_cfn_stack = vpcs.first['Tags'].any? do |tag| 
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
      {score: score, message: message}
    elsif vpcs.count > 1
      # Partial marks if we find multiple even though we expect 1.
      {score: 5, message: "Found multiple custom VPCs [non default VPC] that are avaliable. Uncertain which is the correct one."}
    else
      {score: 0, message: "Failed to find any custom VPC [non default VPC] that is avaliable"}
    end
  end
end # class