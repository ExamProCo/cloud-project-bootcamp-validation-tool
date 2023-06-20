class Aws2023::Validations::Cluster
  def self.should_have_a_cluster(manifest:,specific_params:)
    resource_cluster = Cpbvt::Payloads::Aws::Extractor.cloudformation_list_stacks__by_stack_resource_type(
      manifest,
      'CrdCluster',
      "AWS::ECS::Cluster"
    )
    cluster_name = resource_cluster['PhysicalResourceId']

    clusters = manifest.get_output!("ecs-describe-clusters__#{cluster_name}")
    cluster = clusters['clusters'].first

    found =
    cluster['status'] == 'ACTIVE' &&
    cluster['capacityProviders'].include?('FARGATE')

    if found
      {result: {score: 10, message: "Found a cluster: #{cluster_name} that is ACTIVE for FARGATE"}}
    else
      {result: {score: 0, message: "Failed to find a cluster that is ACTIVE for FARGATE"}}
    end
  end

  def self.should_have_a_task_definition(manifest:,specific_params:)
    data = manifest.get_output!('ecs-list-task-definitions')
    found =
    data['taskDefinitionArns'].any? do |arn|
      arn.match(specific_params.backend_family)
    end

    if found
      {result: {score: 10, message: "Found a task defintition with a family: #{specific_params.backend_family}"}}
    else
      {result: {score: 0, message: "Failed to find a task defintition with a family: #{specific_params.backend_family}"}}
    end
  end

  def self.should_have_an_ecr_repo(manifest:,specific_params:)
    data = manifest.get_output!('ecr-describe-repositories')
    repo = data['repositories'].find{|t| t['repositoryName'] == specific_params.backend_family}
    # [TODO] Check if images are present in the container repo

    if repo
      {result: {score: 10, message: "Found a task defintition with a family: #{specific_params.backend_family}"}}
    else
      {result: {score: 0, message: "Failed to find a task defintition with a family: #{specific_params.backend_family}"}}
    end
  end

  def self.should_have_a_service(manifest:,specific_params:)
    cluster_name = specific_params.cluster_name
    data = manifest.get_output!("ecs-describe-services__#{cluster_name}")
    backend_service = data['services'].find{|t|t['serviceName'] == specific_params.backend_family}

    found = backend_service['status'] == 'ACTIVE'

    if found
      {result: {score: 10, message: "Found a fargate service a #{specific_params.backend_family}"}}
    else
      {result: {score: 0, message: "Failed to find a fargate service a #{specific_params.backend_family}"}}
    end
  end

  def self.should_have_a_running_task(manifest:,specific_params:)
    cluster_name = specific_params.cluster_name
    data = manifest.get_output!("ecs-describe-tasks")

    container = nil
    data['tasks'].each do |task|
      if task['clusterArn'].match(cluster_name)
        container = task['containers'].find do |container|
          container['name'] == specific_params.backend_family
        end
        if container
          break
        end
      end
    end

    healthy = container['healthStatus'] == 'HEALTHY'

    if healthy
      {result: {score: 10, message: "Found an ECS task for: #{specific_params.backend_family} running in the expected cluster and service that is HEALTHY"}}
    else
      {result: {score: 0, message: "Failed to find an ECS task for: #{specific_params.backend_family} running in the expected cluster and service that is HEALTHY"}}
    end
  end

  def self.should_have_an_alb(manifest:,specific_params:)
    cluster_name = specific_params.cluster_name
    service_name = specific_params.backend_family
    data = manifest.get_output!("ecs-describe-services__#{cluster_name}")
    backend_service = data['services'].find{|t|t['serviceName'] == service_name}

    if backend_service.key?('loadBalancers')
      found = backend_service['loadBalancers'].first['containerPort'] = 4567
      if found 
        backend_tg_arn = backend_service['loadBalancers'].first['targetGroupArn']
        {result: {score: 10, message: "Found attached load balancer for the fargate service: #{service_name}"}, backend_tg_arn: backend_tg_arn}
      else
        {result: {score: 5, message: "Failed to find an attached load balancer for the fargate service: #{service_name} for port 4567"}}
      end
    else
      {result: {score: 0, message: "Failed to find an attached load balancer for the fargate service: #{service_name}"}}
    end
  end

  def self.should_have_alb_sg(manifest:,specific_params:)
    resource_alb = Cpbvt::Payloads::Aws::Extractor.cloudformation_list_stacks__by_stack_resource_type(
      manifest,
      'CrdCluster',
      "AWS::ElasticLoadBalancingV2::LoadBalancer"
    )
    alb_arn = resource_alb['PhysicalResourceId']

    data = manifest.get_output!('elbv2-describe-load-balancers')

    alb =
    data['LoadBalancers'].find do |lb|
      lb['LoadBalancerArn'] == alb_arn
    end

    sg_id = alb['SecurityGroups'].first

    sg_data = manifest.get_output!('ec2-describe-security-groups')

    sg = sg_data['SecurityGroups'].find{|t| t['GroupId'] == sg_id}

    http_sg_rule =
    sg['IpPermissions'].find do |rule|
      rule['FromPort'] == 80 &&
      rule['ToPort'] == 80 &&
      rule['IpRanges'].first['CidrIp'] == '0.0.0.0/0'
    end

    https_sg_rule =
    sg['IpPermissions'].find do |rule|
      rule['FromPort'] == 443 &&
      rule['ToPort'] == 443 &&
      rule['IpRanges'].first['CidrIp'] == '0.0.0.0/0'
    end

    if https_sg_rule && http_sg_rule
      {result: {score: 10, message: "Found a Security Group for the ALB with ingress to internet for 80 and 443"}, alb_sg_id: sg_id }
    else
      {result: {score: 0, message: "Failed to find a Security Group for the ALB without ingress to internet for 80 and 443"}}
    end

  end

  def self.should_have_service_sg(manifest:,specific_params:,alb_sg_id:)
    cluster_name = specific_params.cluster_name
    service_name = specific_params.backend_family
    data = manifest.get_output!("ecs-describe-services__#{cluster_name}")
    backend_service = data['services'].find{|t|t['serviceName'] == service_name}

    sg_id = backend_service['networkConfiguration']['awsvpcConfiguration']['securityGroups'].first
    
    sg_data = manifest.get_output!('ec2-describe-security-groups')

    sg = sg_data['SecurityGroups'].find{|t| t['GroupId'] == sg_id}

    alb_sg_rule =
    sg['IpPermissions'].find do |rule|
      rule['FromPort'] == 4567 &&
      rule['ToPort'] == 4567 &&
      rule['UserIdGroupPairs'].first['GroupId'] == alb_sg_id
    end

    if alb_sg_rule
      {result: {score: 10, message: "Found a Security Group for the the backend service with ingress to the ALB SG on port 4567"}, alb_sg_id: sg_id }
    else
      {result: {score: 0, message: "Failed to find a Security Group for the the backend service with ingress to the ALB SG on port 4567"}}
    end
  end

  def self.should_have_target_group(manifest:,specific_params:,backend_tg_arn:)
    tg_id = backend_tg_arn.split("/").last
    data = manifest.get_output!('elbv2-describe-target-groups')
    tg = data['TargetGroups'].find{|t| t['TargetGroupArn'] == backend_tg_arn }

    tg_health_data = manifest.get_output("elbv2-describe-target-health__#{tg_id}")

    found_tg =
    tg['Port'] == 4567 &&
    tg['HealthCheckPort'] == 4567.to_s &&
    tg['HealthCheckEnabled'] == true &&
    tg['HealthCheckPath'] == "/api/health-check"


    desc = tg_health_data['TargetHealthDescriptions'].first

    found_tg_healthcheck = 
    desc['Target']['Port'] == 4567 &&
    desc['HealthCheckPort'] == 4567.to_s &&
    desc['TargetHealth']["State"] == 'healthy'

    if found_tg && found_tg_healthcheck 
      {result: {score: 10, message: "Found Target Group with healthy target to backend-flask on port 4567"}}
    else
      {result: {score: 0, message: "Failed to find Target Group with healthy target to backend-flask on port 4567"}}
    end
  end

  def self.should_have_cloudmap_namespace(manifest:,specific_params:)
    data = manifest.get_output!('servicediscovery-list-namespaces')
    found = 
    data['Namespaces'].find do |service|
      service['Name'] == 'cruddur'
    end

    if found 
      {result: {score: 10, message: "Found a CloudMap Namespace named cruddur"}}
    else
      {result: {score: 0, message: "Failed to find a CloudMap Namespace named cruddur"}}
    end
  end

  def self.should_have_cloudmap_service(manifest:,specific_params:)
    service_name = specific_params.backend_family
    data = manifest.get_output!('servicediscovery-list-services')

    found = 
    data['Services'].find do |service|
      service['Name'] == service_name
    end

    if found 
      {result: {score: 10, message: "Found a CloudMap Service named #{service_name}"}}
    else
      {result: {score: 0, message: "Failed to find a CloudMap Service named #{service_name}"}}
    end
  end

end