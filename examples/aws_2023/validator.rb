require 'pp'

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

  state = Aws2023::State.new

  raise "Validator.run: run_uuid should not be null" if run_uuid.nil?
  raise "Validator.run: user_uuid should not be null" if user_uuid.nil?
  raise "Validator.run: project_scope should not be null" if project_scope.nil?
  raise "Validator.run: output_path should not be null" if output_path.nil?
  raise "Validator.run: region should not be null" if region.nil?
  raise "Validator.run: aws_access_key_id should not be null" if aws_access_key_id.nil?
  raise "Validator.run: aws_secret_access_key should not be null" if aws_secret_access_key.nil?
  raise "Validator.run: payloads_bucket should not be null" if payloads_bucket.nil?

  manifest = Cpbvt::Manifest.new(
    user_uuid: user_uuid,
    run_uuid: run_uuid,
    output_path: output_path,
    project_scope: project_scope,
    payloads_bucket: payloads_bucket
  )
  manifest.load_from_file!
  manifest.pull!
  state.manifest = manifest

  self.networking_validations state
  self.cicd_validations state

  pp state.results

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

  def self.networking_validations state
    state.process(
      klass: Aws2023::Validations::Networking,
      function_name: :should_have_custom_vpc, 
      output_params: [:vpc_id]
    )
    state.process(
      klass: Aws2023::Validations::Networking,
      function_name: :should_have_three_public_subnets, 
      input_params: [:vpc_id],
      output_params: [:public_subnet_id_1]
    )
    state.process(
      klass: Aws2023::Validations::Networking,
      function_name: :should_have_an_igw,
      input_params: [:vpc_id],
      output_params: [:igw_id]
    )
    state.process(
      klass: Aws2023::Validations::Networking,
      function_name: :should_have_a_route_to_internet,
      input_params: [:igw_id,:vpc_id]
    )
  end

  def self.cicd_validations state
    state.process(
      klass: Aws2023::Validations::Cicd,
      function_name: :should_have_a_codepipeline,
      output_params: [:pipeline_name]
    )
    # should have a codepipeline
    # with a source from github to the expected bootcamp repo
    # with a build step to codebuild
    # with deployment using ECS deployer
  end
end # class