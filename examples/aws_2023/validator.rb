require 'pp'

class Aws2023::Validator

  def self.run(general_params:,specific_params:)
    unless general_params.valid?
      puts general_params.errors.full_messages
      raise "failed to pass general params validation"
    end

    unless specific_params.valid?
      puts specific_params.errors.full_messages
      raise "failed to specific params validation"
    end

    state = Aws2023::State.new

    manifest = Cpbvt::Manifest.new(
      user_uuid: general_params.user_uuid,
      run_uuid: general_params.run_uuid,
      output_path: general_params.output_path,
      project_scope: general_params.project_scope,
      payloads_bucket: general_params.payloads_bucket
    )
    manifest.load_from_file!
    manifest.pull!
    state.manifest = manifest
    state.specific_params = specific_params

    #self.networking_validations state
    self.cluster_validations state
    #self.cicd_validations state

    pp state.results

    # IaC Validation
      # should have CFN stacks named the following: <stack_names>


      # should have a cloud map namespace named <cloudmap_namespace>
    
    # Frontend Static Website Hosting Validation
      # should have an s3 bucket called <s3-website-bucket-name>
        # with cors?
        # with block public access turnred off?
        # with a bucket policy?
      # should have a CFN distribution

    # == Primary Db Validation
    # - should have an RDS instance running
    # - the RDS instance should be publically avaliable
    # - the RDS instance should have a security group <sg-rds-id>
    # - and it should provide access to the fargate service security group <sg-serv-id> on port 5432

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
    state.process(
      klass: Aws2023::Validations::Cicd,
      function_name: :should_have_a_source_from_github,
      input_params: [:pipeline_name]
    )
    state.process(
      klass: Aws2023::Validations::Cicd,
      function_name: :should_have_a_build_stage,
      input_params: [:pipeline_name]
    )
    state.process(
      klass: Aws2023::Validations::Cicd,
      function_name: :should_have_a_deploy_stage,
      input_params: [:pipeline_name]
    )
  end

  def self.cluster_validations state
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_a_cluster
    )
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_a_task_definition
    )
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_an_ecr_repo
    )
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_a_service
    )
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_a_running_task
    )
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_an_alb
    )
    #state.process(
    #  klass: Aws2023::Validations::Cluster,
    #  function_name: :should_have_alb_sg
    #)
    #state.process(
    #  klass: Aws2023::Validations::Cluster,
    #  function_name: :should_have_service_sg
    #)
  end
    # Primary Compute Validation
      # Should have an ECS cluster named <cluster_name>
        # with fargate service running named <service_name> on port 4567
          # and the service should have a security group <sg-serv-id>
            # and it should provide access to the  alb securitygroup <sg-alb-id> on port 4567

end # class