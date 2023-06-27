Cpbvt::Tester::Runner.describe :cluster do
  spec :should_have_a_cluster do |t|
    cluster_name = assert_cfn_resource('CrdCluster',"AWS::ECS::Cluster").returns('PhysicalResourceId')

    cluster = assert_load("ecs-describe-clusters__#{cluster_name}",'clusters').returns(:first)

    assert_eq(cluster,'status','ACTIVE')
    assert_include?(cluster,'capacityProviders','FARGATE')

    set_pass_message "Found a cluster: #{cluster_name} that is ACTIVE for FARGATE"
    set_fail_message "Failed to find a cluster that is ACTIVE for FARGATE"
  end

  spec :should_have_a_task_definition do |t|
    family = t.specific_params.backend_family
    task_def_arns = assert_load('ecs-list-task-definitions','taskDefinitionArns').returns(:all)

    arn =
    assert_find(task_def_arns) do |assert, arn| 
      assert.expects_match(arn,family)
    end.returns(:all)

    assert_not_nil arn

    set_pass_message "Found a task defintition with a family: #{family}"
    set_fail_message "Failed to find a task defintition with a family: #{family}"
  end

  spec :should_have_an_ecr_repo do |t|
    family = t.specific_params.backend_family
    data = assert_load('ecr-describe-repositories','repositories').find('repositoryName',family).returns(:all)

    # [TODO] Check if images are present in the container repo

    set_pass_message "Found a task defintition with a family: #{family}"
    set_fail_message "Failed to find a task defintition with a family: #{family}"
  end

  spec :should_have_a_service do |t|
    cluster_name = t.specific_params.cluster_name
    family = t.specific_params.backend_family

    backend_service = assert_load("ecs-describe-services__#{cluster_name}",'services')
      .find('serviceName', family)
      .returns(:all)

    assert_json(backend_service,'status').expects_eq('ACTIVE')

    set_pass_message "Found a fargate service a #{family}"
    set_fail_message "Failed to find a fargate service a #{family}"
  end

  spec :should_have_a_running_task do |t|
    family = t.specific_params.backend_family
    cluster_name = t.specific_params.cluster_name
    tasks = assert_load("ecs-describe-tasks",'tasks').returns(:all)

    assert_json(tasks).expects_not_nil

    container = nil
    tasks.each do |task|
      if task['clusterArn'].match(cluster_name)
        container = task['containers'].find do |container|
          container['name'] == family
        end
        break if container
      end
    end

    assert_json(container,'healthStatus').expects_eq('HEALTHY')

    set_pass_message "Found an ECS task for: #{family} running in the expected cluster and service that is HEALTHY"
    set_fail_message "Failed to find an ECS task for: #{family} running in the expected cluster and service that is HEALTHY"
  end

  spec :should_have_an_alb do |t|
    cluster_name = t.specific_params.cluster_name
    family = t.specific_params.backend_family

    backend_service = assert_load("ecs-describe-services__#{cluster_name}",'services')
      .find('serviceName', family)
      .returns(:all)

    alb = assert_json(backend_service,'loadBalancers').returns(:first)

    backend_tg_arn = false

    assert_json(alb,'containerPort').expects_eq(4567)

    backend_tg_arn = assert_json(alb,'targetGroupArn').returns(:all)

    set_pass_message "Found attached load balancer for the fargate service: #{family}"
    set_fail_message "Failed to find an attached load balancer for the fargate service: #{family} for port 4567"

    set_state_value :backend_tg_arn, backend_tg_arn
  end

  spec :should_have_alb_sg do |t|
    alb_arn = assert_cfn_resource('CrdCluster',"AWS::ElasticLoadBalancingV2::LoadBalancer").returns('PhysicalResourceId')

    alb = assert_load('elbv2-describe-load-balancers','LoadBalancers').find('LoadBalancerArn',alb_arn).returns(:all)

    sg_id = false
    sg_id = assert_json(alb,'SecurityGroups').returns(:first)

    sg = assert_load('ec2-describe-security-groups','SecurityGroups').find('GroupId',sg_id).returns(:all)

    rules = assert_json(sg,'IpPermissions').returns(:all)

    http_sg_rule =
    assert_find(rules) do |assert,rule|
      assert.expects_eq(rule,'FromPort', 80)
      assert.expects_eq(rule,'ToPort', 80)
      range = rule['IpRanges'].first
      assert.expects_eq(range,'CidrIp','0.0.0.0/0')
    end

    https_sg_rule =
    assert_find(rules) do |assert,rule|
      assert.expects_eq(rule,'FromPort', 443)
      assert.expects_eq(rule,'ToPort', 443)
      range = rule['IpRanges'].first
      assert.expects_eq(range,'CidrIp','0.0.0.0/0')
    end

    assert_not_nil(http_sg_rule)
    assert_not_nil(https_sg_rule)

    set_state_value :alb_sg_id, sg_id

    set_pass_message "Found a Security Group for the ALB with ingress to internet for 80 and 443"
    set_fail_message "Failed to find a Security Group for the ALB without ingress to internet for 80 and 443"
  end

  spec :should_have_service_sg do |t|
    cluster_name = t.specific_params.cluster_name
    family = t.specific_params.backend_family
    alb_sg_id = t.dynamic_params.alb_sg_id

    backend_service = assert_load("ecs-describe-services__#{cluster_name}",'services')
      .find('serviceName', family)
      .returns(:all)

    sg_id = assert_json(backend_service,'networkConfiguration','awsvpcConfiguration','securityGroups').returns(:first)

    sg = assert_load('ec2-describe-security-groups','SecurityGroups').find('GroupId',sg_id).returns(:all)

    rules = assert_json(sg,'IpPermissions').returns(:all)

    alb_sg_rule =
    assert_find(rules) do |assert,rule|
      assert.expects_eq(rule,'FromPort', 4567)
      assert.expects_eq(rule,'ToPort', 4567)
      pair = rule['UserIdGroupPairs'].first
      assert.expects_eq(pair,'GroupIp',alb_sg_id)
    end

    assert_not_nil(alb_sg_rule)

    set_state_value :serv_sg_id, sg_id

    set_pass_message "Found a Security Group for the the backend service with ingress to the ALB SG on port 4567"
    set_fail_message "Failed to find a Security Group for the the backend service with ingress to the ALB SG on port 4567"
  end

  spec :should_have_target_group do |t|
    backend_tg_arn = t.dynamic_params.backend_tg_arn

    tg_id = backend_tg_arn.split("/").last

    tg = assert_load('elbv2-describe-target-groups','TargetGroups').find('TargetGroupArn',backend_tg_arn).returns(:all)
    tg_health_data = assert_load("elbv2-describe-target-health__#{tg_id}").returns(:all)

    assert_json(tg,'Port').expects_eq(4567)
    assert_json(tg,'HealthCheckPort').expects_eq(4567.to_s)
    assert_json(tg,'HealthCheckEnabled').expects_true
    assert_json(tg,'HealthCheckPath').expects_eq('/api/health-check')

    desc = assert_json(tg_health_data,'TargetHealthDescriptions').returns(:first)

    assert_json(desc,'Target','Port').expects_eq(4567)
    assert_json(desc,'HealthCheckPort').expects_eq(4567.to_s)
    assert_json(desc,'TargetHealth','State').expects_eq('healthy')

    set_pass_message "Found Target Group with healthy target to backend-flask on port 4567"
    set_fail_message "Failed to find Target Group with healthy target to backend-flask on port 4567"
  end

  spec :should_have_cloudmap_namespace do |t|
    namespace = assert_load('servicediscovery-list-namespaces','Namespaces').find('Name','cruddur').returns(:all)

    assert_not_nil(namespace)

    set_pass_message "Found a CloudMap Namespace named cruddur"
    set_fail_message "Failed to find a CloudMap Namespace named cruddur"
  end

  spec :should_have_route53_to_alb do |t|
    naked_domain_name = t.specific_params.naked_domain_name

    alb_arn = assert_cfn_resource('CrdCluster',"AWS::ElasticLoadBalancingV2::LoadBalancer").returns('PhysicalResourceId')

    alb = assert_load('elbv2-describe-load-balancers','LoadBalancers').find('LoadBalancerArn',alb_arn).returns(:all)

    alb_domain_name = "dualstack.#{alb['DNSName'].downcase}"

    zone_arn = assert_load('route53-list-hosted-zones','HostedZones').find('Name',"#{naked_domain_name}.").returns('Id')

    zone_id = zone_arn.split("/").last

    record_sets = assert_load("route53-list-resource-record-sets__#{zone_id}").returns('ResourceRecordSets')

    record =
    assert_find(record_sets) do |assert,record|
      assert.expects_eq(record,'Name',"api.#{naked_domain_name}.")
      assert.expects_eq(record,'Type',"A")
    end.returns(:all)

    assert_json(record,'AliasTarget','DNSName').expects_eq("#{alb_domain_name}.")

    set_pass_message "Found route53 pointing to domain name for the api"
    set_fail_message "Failed to find route53 pointing to domain name for the api"
  end
end