class Aws2023::Puller
  def self.run(project_scope:,
               user_uuid:,
               run_uuid:,
               region:,
               user_region:,
               output_path:,
               aws_access_key_id:,
               aws_secret_access_key:,
               payloads_bucket:
              )

    manifest = Cpbvt::Manifest.new(
      user_uuid: user_uuid, 
      run_uuid: run_uuid, 
      project_scope: project_scope,
      output_path: output_path,
      payloads_bucket: payloads_bucket
    )

    general_params = {
      project_scope: project_scope,
      run_uuid: run_uuid,
      user_uuid: user_uuid,
      region: region,
      user_region: user_region,
      output_path: output_path,
      aws_access_key_id: aws_access_key_id,
      aws_secret_access_key: aws_secret_access_key,
      payloads_bucket: payloads_bucket
    }

    Cpbvt::Aws2023.pull_primary_region_aws_resources(
      manifest: manifest,
      general_params: general_params
    )
    Cpbvt::Aws2023.pull_alternate_specific_aws_resources(
      manifest: manifest,
      general_params: general_params
    )
    Cpbvt::Aws2023.pull_global_resources(
      manifest: manifest,
      general_params: general_params
    )
    Cpbvt::Aws2023.pull_specific_aws_resources(
      manifest: manifest,
      general_params: general_params
    )
    Cpbvt::Aws2023.pull_specific_global_aws_resources(
      manifest: manifest,
      general_params: general_params
    )

    # Complex usecase
    complex = [
      {
        command: 'cognito_idp_describe_user_pool_client',
        params: {
          user_pool_id: 'cognito_idp_list_user_pools',
          client_id: 'cognito_idp_list_user_pool_clients'
        }
      },
      {
        command: 'ecs_describe_tasks',
        params: {
          cluster: 'ecs_describe_clusters',
          tasks: 'ecs_list_tasks' # requires family and cluster
        }
      },
      {
        command: 'ecs_list_tasks',
        params: {
          cluster: '',
          family: ''
        }
      },
      {
        command: 'elbv2_describe_rules',
      }
    ]
    # A list of up to 100 cluster names or full cluster Amazon Resource Name (ARN) entries. If you do not specify a cluster, the default cluster is assumed.
    # - ecs_describe_services


    manifest.write_file
    Cpbvt::Uploader.run(
      file_path: manifest.output_file, 
      object_key: manifest.object_key,
      aws_region: region,
      aws_access_key_id: aws_access_key_id,
      aws_secret_access_key: aws_secret_access_key,
      payloads_bucket: payloads_bucket
    )
  end # def self.run

  def self.pull_primary_region_aws_resources(manifest:, general_params:)
    # Primary Region-Specific Commands
    commands = %w{
      acm_list_certificates
      apigatewayv2_get_apis
      cloudformation_list_stacks
      codebuild_list_projects
      codebuild_list_builds
      codepipeline_list_pipelines
      cognito_idp_list_user_pools
      dynamodb_list_tables
      dynamodbstreams_list_streams
      ec2_describe_vpcs
      ec2_describe_subnets
      ec2_describe_route_tables
      ec2_describe_internet_gateways
      ec2_describe_security_groups
      ec2_describe_route_tables
      ecr_describe_repositories
      ecs_describe_clusters
      ecs_list_task_definitions
      elbv2_describe_load_balancers
      elbv2_describe_target_groups
      lambda_list_functions
      lambda_list_layers
      rds_describe_db_instances
      rds_describe_db_subnet_groups
      rds_describe_db_snapshots
      route53_list_hosted_zones
      servicediscovery_list_services
      servicediscovery_list_namespaces
    }
    commands.each do |command|
      result = Cpbvt::Payloads::Aws::Runner.run command, general_params.merge({
        filename: "#{command.gsub('_','-')}.json"
      })
      manifest.add_payload command, result
    end
  end

  def self.pull_alternate_specific_aws_resources(manifest:, general_params:)
    # Alternate Region-Specific Commands
    # - acm_list_certificates for CloudFront since it has to use one in us-east-1
    commands = %w{
      acm_list_certificates
    }
    commands = [] # override
    commands.each do |command|
      result = Cpbvt::Payloads::Aws::Runner.run command, general_params.merge({
        user_region: 'us-east-1',
        filename: "#{command.gsub('_','-')}.json"
      })
      manifest.add_payload command, result
    end
  end

  # Global Commands
  def self.pull_global_resources(manifest:, general_params:)
    commands = %w{
      cloudfront_list_distributions
      s3api_list_buckets
    }
    commands.each do |command|
      result = Cpbvt::Payloads::Aws::Runner.run command, general_params.merge({
        user_region: 'global',
        filename: "#{command.gsub('_','-')}.json"
      })
      manifest.add_payload command, result
    end
  end

  def self.pull_specific_aws_resources(manifest:, general_params:)
    # Specific Regional AWS Resources Commands
    commands = [
      {
        command: 'acm_describe_certificate',
        params: {certificate_arn: 'acm_list_certificates'}
      },
      {
        command: 'apigatewayv2_get_authorizers',
        params: {app_id: 'apigatewayv2_get_apis'}
      },
      {
        command: 'apigatewayv2_get_integrations',
        params: {app_id: 'apigatewayv2_get_apis'}
      },
      {
        command: 'cloudformation_list_stack_resources',
        params: {stack_name: 'cloudformation_list_stacks'}
      },
      {
        command: 'codepipeline_get_pipeline',
        params: {pipeline_name: 'codepipeline_list_pipelines'}
      },
      {
        command: 'cognito_idp_describe_user_pool',
        params: {user_pool_id: 'cognito_idp_list_user_pools'}
      },
      {
        command: 'cognito_idp_list_user_pool_clients',
        params: {user_pool_id: 'cognito_idp_list_user_pools'}
      },
      {
        command: 'cognito_idp_list_users',
        params: {user_pool_id: 'cognito_idp_list_user_pools'}
      },
      {
        command: 'dynamodb_describe_table',
        params: {table_name: 'dynamodb_list_tables'}
      },
      {
        command: 'dynamodbstreams_describe_stream',
        params: {stream_arn: 'dynamodbstreams_list_streams' }
      },
      {
        command: 'ecr_describe_images',
        params: {repository_name: 'ecr_describe_repositories'}
      },
      {
        command: 'elbv2_describe_listeners',
        params: {load_balancer_arn: 'elbv2_describe_load_balancers'}
      },
      {
        command: 'elbv2_describe_load_balancer_attributes',
        params: {load_balancer_arn: 'elbv2_describe_load_balancers'}
      },
      {
        command: 'elbv2_describe_target_group_attributes',
        params: {target_group_arn: 'elbv2_describe_target_groups'}
      },
      {
        command: 'lambda_get_function' ,
        params: {function_name: 'lambda_list_functions'}
      },
      {
        command: 'route53_get_hosted_zone',
        params: {hosted_zone_id: 'route53_list_hosted_zones'}
      },
      {
        command: 'route53_list_resource_record_sets',
        params: {hosted_zone_id: 'route53_list_hosted_zones'}
      }
    ]
    commands.each do |attrs|
      Cpbvt::Payloads::Aws::Runner.iter_run!(
        manifest: manifest,
        command: attrs[:command], 
        specific_params: attrs[:params], 
        general_params: general_params.merge({
          filename: "#{attrs[:command].gsub('_','-')}.json"
        })
      )
    end
  end

  # Specific Regional AWS Resources Commands
  def self.pull_specific_global_aws_resources(manifest:, general_params:)
    commands = [
      {
        command: 'cloudfront_get_distribution',
        params: {distribution_id: 'cloudfront_list_distributions'}
      },
      {
        command: 'cloudfront_list_invalidations',
        params: {distribution_id: 'cloudfront_list_distributions'}
      },
      {
        command: 's3api_get_bucket_notification_configuration',
        params: {bucket: 's3api_list_buckets'}
      },
      {
        command: 's3api_get_bucket_policy',
        params: {bucket: 's3api_list_buckets'}
      },
      {
        command: 's3api_get_bucket_cors',
        params: {bucket: 's3api_list_buckets'}
      },
      {
        command: 's3api_get_bucket_website',
        params: {bucket: 's3api_list_buckets'}
      },
      {
        command: 's3api_get_public_access_block',
        params: {bucket: 's3api_list_buckets'}
      }
    ]
    commands.each do |attrs|
      Cpbvt::Payloads::Aws::Runner.iter_run!(
        manifest: manifest,
        command: attrs[:command], 
        specific_params: attrs[:params], 
        general_params: general_params.merge({
          user_region: 'global',
          filename: "#{attrs[:command].gsub('_','-')}.json"
        })
      )
    end
    # - s3api_head_bucket
    # - s3api_get_head_object
    # - s3api_get_object
    # - s3api_list_objects_v2
  end
end # class AwsBootcamp2023