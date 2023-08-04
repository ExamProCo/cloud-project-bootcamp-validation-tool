require 'async'

class Aws2023::Puller
  def self.run(general_params:,specific_params:)
    unless general_params.valid?
      puts general_params.errors.full_messages
      raise "failed to pass general params validation"
    end

    unless specific_params.valid?
      puts specific_params.errors.full_messages
      raise "failed to specific params validation"
    end

    manifest = Cpbvt::Manifest.new(
      user_uuid: general_params.user_uuid, 
      run_uuid: general_params.run_uuid, 
      project_scope: general_params.project_scope,
      output_path: general_params.output_path,
      payloads_bucket: general_params.payloads_bucket
    )

    creds = Cpbvt::Payloads::Aws::Command.session_token general_params.target_aws_account_id, general_params.run_uuid
    general_params.tmp_aws_access_key_id = creds['AccessKeyId']
    general_params.tmp_aws_secret_access_key = creds['SecretAccessKey']
    general_params.tmp_aws_session_token = creds['SessionToken']

    primary_region = general_params.user_region
    Async do |task|
      cluster_name = specific_params.cluster_name
      self.pull_cluster_async task, cluster_name, primary_region, :ecs_describe_clusters, manifest, general_params
      self.pull_cluster_async task, cluster_name, primary_region, :ecs_list_services    , manifest, general_params
      self.pull_cluster_async task, cluster_name, primary_region, :ecs_describe_services, manifest, general_params, { services: [specific_params.ecs_service_name]}
      self.pull_async task, primary_region, :ecs_list_tasks, manifest, general_params, {cluster_name: specific_params.cluster_name, family: specific_params.backend_family}
      self.pull_async task, primary_region, :acm_list_certificates, manifest, general_params
      self.pull_async task, primary_region, :apigatewayv2_get_apis, manifest, general_params
      self.pull_async task, primary_region, :cloudformation_list_stacks, manifest, general_params
      self.pull_async task, primary_region, :codebuild_list_projects, manifest, general_params
      self.pull_async task, primary_region, :codebuild_list_builds, manifest, general_params
      self.pull_async task, primary_region, :codepipeline_list_pipelines, manifest, general_params
      self.pull_async task, primary_region, :cognito_idp_list_user_pools, manifest, general_params
      self.pull_async task, primary_region, :dynamodb_list_tables, manifest, general_params
      self.pull_async task, primary_region, :dynamodbstreams_list_streams, manifest, general_params
      self.pull_async task, primary_region, :ec2_describe_vpcs, manifest, general_params
      self.pull_async task, primary_region, :ec2_describe_subnets, manifest, general_params
      self.pull_async task, primary_region, :ec2_describe_route_tables, manifest, general_params
      self.pull_async task, primary_region, :ec2_describe_internet_gateways, manifest, general_params
      self.pull_async task, primary_region, :ec2_describe_security_groups, manifest, general_params
      self.pull_async task, primary_region, :ec2_describe_route_tables, manifest, general_params
      self.pull_async task, primary_region, :ecr_describe_repositories, manifest, general_params
      self.pull_async task, primary_region, :ecs_list_task_definitions, manifest, general_params
      self.pull_async task, primary_region, :elbv2_describe_load_balancers, manifest, general_params
      self.pull_async task, primary_region, :elbv2_describe_target_groups, manifest, general_params
      self.pull_async task, primary_region, :lambda_list_functions, manifest, general_params
      self.pull_async task, primary_region, :lambda_list_layers, manifest, general_params
      self.pull_async task, primary_region, :rds_describe_db_instances, manifest, general_params
      self.pull_async task, primary_region, :rds_describe_db_subnet_groups, manifest, general_params
      self.pull_async task, primary_region, :rds_describe_db_snapshots, manifest, general_params
      self.pull_async task, 'global', :route53_list_hosted_zones, manifest, general_params
      self.pull_async task, primary_region, :servicediscovery_list_services, manifest, general_params
      self.pull_async task, primary_region, :servicediscovery_list_namespaces, manifest, general_params
      self.pull_async task, 'us-east-1', :acm_list_certificates, manifest, general_params
      self.pull_async task, 'global', :cloudfront_list_distributions, manifest, general_params
      self.pull_async task, 'global', :s3api_list_buckets, manifest, general_params
    end

    # Listing ECS tasks
    data = manifest.get_output!('ecs_list_tasks')
    tasks = Cpbvt::Payloads::Aws::Extractor.ecs_list_tasks__task_id(data)
    task_ids = tasks.map{|t|t[:task_id]}
    self.pull primary_region, :ecs_describe_tasks, manifest, general_params, {cluster_name: specific_params.cluster_name, task_ids: task_ids}

    # ============================================
    # Global Region Specific =====================
    # ============================================
    aliases = [
      "#{specific_params.naked_domain_name}",
      "assets.#{specific_params.naked_domain_name}"
    ]
    Async do |task|
      self.pull_specific_async(task,'global',{
        command: 'cloudfront_get_distribution',
        params: {distribution_id: 'cloudfront_list_distributions'},
        filters: {
          aliases: aliases
        }
      }, manifest, general_params)
      self.pull_specific_async(task,'global',{
        command: 'cloudfront_list_invalidations',
        params: {distribution_id: 'cloudfront_list_distributions'},
        filters: {
          aliases: aliases
        }
      }, manifest, general_params)
    end
    bucket_names =  [
      specific_params.naked_domain_name,
      "www.#{specific_params.naked_domain_name}",
      "assets.#{specific_params.naked_domain_name}"
    ]
    bucket_names_events = [
      specific_params.raw_assets_bucket_name,
      "assets.#{specific_params.naked_domain_name}"
    ]
    Async do |task|
      self.pull_specific_async(task,'global',{
        command: 's3api_get_bucket_notification_configuration',
        params: {bucket: 's3api_list_buckets'},
        filters: {
          bucket_names: bucket_names_events
        }
      }, manifest, general_params)
      self.pull_specific_async(task,'global',{
        command: 's3api_get_bucket_policy',
        params: {bucket: 's3api_list_buckets'},
        filters: {
          bucket_names: bucket_names
        }
      }, manifest, general_params)
      # We never needed changed CORS for S3 Buckets apparently...
      #self.pull_specific_async(task,'global',{
      #  command: 's3api_get_bucket_cors',
      #  params: {bucket: 's3api_list_buckets'},
      #  filters: {
      #    bucket_names: bucket_names
      #  }
      #}, manifest, general_params)
      self.pull_specific_async(task,'global',{
        command: 's3api_get_bucket_website',
        params: {bucket: 's3api_list_buckets'},
        filters: {
          bucket_names: bucket_names
        }
      }, manifest, general_params)
      self.pull_specific_async(task,'global',{
        command: 's3api_get_public_access_block',
        params: {bucket: 's3api_list_buckets'},
        filters: {
          bucket_names: bucket_names
        }
      }, manifest, general_params)
    end
    # ============================================
    # Primary Region Specific ====================
    # ============================================
    Async do |task|
      self.pull_specific_async(task,primary_region,{
        command: 'codebuild_batch_get_projects',
        params: {project_name: 'codebuild_list_projects'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'acm_describe_certificate',
        params: {certificate_arn: 'acm_list_certificates'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'apigatewayv2_get_routes',
        params: {app_id: 'apigatewayv2_get_apis'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'apigatewayv2_get_authorizers',
        params: {app_id: 'apigatewayv2_get_apis'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'apigatewayv2_get_integrations',
        params: {app_id: 'apigatewayv2_get_apis'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'cloudformation_list_stack_resources',
        params: {stack_name: 'cloudformation_list_stacks'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'codepipeline_get_pipeline',
        params: {pipeline_name: 'codepipeline_list_pipelines'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'cognito_idp_describe_user_pool',
        params: {user_pool_id: 'cognito_idp_list_user_pools'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'cognito_idp_list_user_pool_clients',
        params: {user_pool_id: 'cognito_idp_list_user_pools'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'cognito_idp_list_users',
        params: {user_pool_id: 'cognito_idp_list_user_pools'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'dynamodb_describe_table',
        params: {table_name: 'dynamodb_list_tables'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'dynamodbstreams_describe_stream',
        params: {stream_arn: 'dynamodbstreams_list_streams' }
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'ecr_describe_images',
        params: {repository_name: 'ecr_describe_repositories'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'elbv2_describe_listeners',
        params: {load_balancer_arn: 'elbv2_describe_load_balancers'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'elbv2_describe_load_balancer_attributes',
        params: {load_balancer_arn: 'elbv2_describe_load_balancers'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'elbv2_describe_target_group_attributes',
        params: {target_group_arn: 'elbv2_describe_target_groups'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'elbv2_describe_target_health',
        params: {target_group_arn: 'elbv2_describe_target_groups'}
      }, manifest, general_params)
      self.pull_specific_async(task,primary_region,{
        command: 'lambda_get_function' ,
        params: {function_name: 'lambda_list_functions'}
      }, manifest, general_params)
      self.pull_specific_async(task,'global',{
        command: 'route53_get_hosted_zone',
        params: {hosted_zone_id: 'route53_list_hosted_zones'}
      }, manifest, general_params)
      self.pull_specific_async(task,'global',{
        command: 'route53_list_resource_record_sets',
        params: {hosted_zone_id: 'route53_list_hosted_zones'}
      }, manifest, general_params)
    end

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
        command: 'elbv2_describe_rules'
      }
    ]

    # A list of up to 100 cluster names or full cluster Amazon Resource Name (ARN) entries. If you do not specify a cluster, the default cluster is assumed.
    # - ecs_describe_services
    manifest.write_file!
    manifest.archive!

    Cpbvt::Uploader.run(
      file_path: manifest.output_file, 
      object_key: manifest.object_key,
      aws_region: general_params.region,
      aws_access_key_id: general_params.aws_access_key_id,
      aws_secret_access_key: general_params.aws_secret_access_key,
      payloads_bucket: general_params.payloads_bucket
    )
  end # def self.run

  def self.pull_cluster_async(task,cluster_name,user_region,command,manifest,general_params,specific_params={})
    specific_params.merge!({cluster_name: cluster_name})
    task.async do
      result = Cpbvt::Payloads::Aws::Runner.run(
        command.to_s, 
        general_params.to_h.merge({
          filename: "#{command.to_s.gsub('_','-')}__#{cluster_name}.json",
          user_region: user_region
        }),
        specific_params
      )
      manifest.add_payload result[:id], result
    end
  end

  def self.pull_async(task,user_region,command,manifest,general_params,specific_params={})
    task.async do
      self.pull(user_region,command,manifest,general_params,specific_params)
    end
  end

  def self.pull(user_region,command,manifest,general_params,specific_params={})
    result = Cpbvt::Payloads::Aws::Runner.run(
      command.to_s, 
      general_params.to_h.merge({
        user_region: user_region
      }),
      specific_params
    )
    manifest.add_payload result[:id], result
  end

  def self.pull_specific_async(task,user_region, rule, manifest, general_params)
    task.async do
      self.pull_specific(user_region, rule, manifest, general_params)
    end
  end

  # Specific Regional AWS Resources Commands
  def self.pull_specific(user_region, rule, manifest, general_params)
    results = Cpbvt::Payloads::Aws::Runner.iter_run!(
      manifest: manifest,
      command: rule[:command], 
      extractor_filters: rule[:filters],
      specific_params: rule[:params], 
      general_params: general_params.to_h.merge({
        user_region: user_region,
      })
    )
    results.each do |result|
      manifest.add_payload result[:id], result
    end
  end
  # - s3api_head_bucket
  # - s3api_get_head_object
  # - s3api_get_object
  # - s3api_list_objects_v2
end # class