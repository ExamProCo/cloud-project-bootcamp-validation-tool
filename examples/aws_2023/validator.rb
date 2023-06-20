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

    self.networking_validations state
    self.cluster_validations state
    #self.cicd_validations state
    #self.iac_validations state
    #self.static_website_hosting_validations state
    self.db_validations state

    pp state.results


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
      function_name: :should_have_an_alb,
      output_params: [:backend_tg_arn]
    )
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_target_group,
      input_params: [:backend_tg_arn]
    )
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_alb_sg,
      output_params: [:alb_sg_id]
    )
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_service_sg,
      input_params: [:alb_sg_id],
      output_params: [:serv_sg_id]
    )
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_cloudmap_namespace
    )

    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_cloudmap_service
    )
    state.process(
      klass: Aws2023::Validations::Cluster,
      function_name: :should_have_route53_to_alb
    )
  end

  def self.iac_validations state
    stacks = %w(
      CrdMachinueUser
      CrdSrvBackendFlask
      CrdSyncRole
      CrdFrontend
      CrdCicd
      CrdDb
      CrdDdb
      CrdCluster
      CrdNet
      ThumbingServerlessCdkStack
      CDKToolkit
    )
    stacks.each do |stack_name|
      state.process(
        klass: Aws2023::Validations::Iac,
        function_name: :should_have_stack,
        override_params: {stack_name: stack_name},
        rule_name: "should_have_#{stack_name}".downcase.to_sym
      )
    end
  end

  def self.static_website_hosting_validations state
    # with cors? - turns out we don't need to check it

    state.process(
      klass: Aws2023::Validations::StaticWebsiteHosting,
      function_name: :should_have_a_naked_domain_bucket_static_website_hosting
    )
    state.process(
      klass: Aws2023::Validations::StaticWebsiteHosting,
      function_name: :should_have_a_www_bucket_with_redirect
    )
    state.process(
      klass: Aws2023::Validations::StaticWebsiteHosting,
      function_name: :should_unblock_public_access
    )
    state.process(
      klass: Aws2023::Validations::StaticWebsiteHosting,
      function_name: :should_have_bucket_policy
    )
    state.process(
      klass: Aws2023::Validations::StaticWebsiteHosting,
      function_name: :should_have_a_cloudfront_distrubition_to_static_website,
      output_params: [
        :static_website_distribution_id,
        :static_website_distribution_domain_name
      ]
    )
    state.process(
      klass: Aws2023::Validations::StaticWebsiteHosting,
      function_name: :should_have_ran_invalidation_on_distrubition,
      input_params: [:static_website_distribution_id]
    )
    state.process(
      klass: Aws2023::Validations::StaticWebsiteHosting,
      function_name: :should_have_support_for_spa,
      input_params: [:static_website_distribution_id]
    )
    state.process(
      klass: Aws2023::Validations::StaticWebsiteHosting,
      function_name: :should_have_route53_to_distribution,
      input_params: [:static_website_distribution_domain_name]
    )
  end

  def self.db_validations state
    state.process(
      klass: Aws2023::Validations::Db,
      function_name: :should_have_public_rds_instance,
      input_params: [:vpc_id]
    )
    state.process(
      klass: Aws2023::Validations::Db,
      function_name: :should_have_db_sg,
      input_params: [:serv_sg_id]
    )
  end

end # class