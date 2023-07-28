Cpbvt::Tester::Runner.describe :serverless do
  spec :should_have_key_upload_route do |t|
    api_id = t.specific_params.apigateway_api_id
    bucket_name = t.specific_params.raw_assets_bucket_name

    route = assert_load("apigatewayv2-get-routes__#{api_id}",'Items').find('RouteKey',"POST /avatars/key_upload").returns(:all)

    target_arn = assert_json(route,'Target').returns(:all)
      
    integration_id = target_arn.split('/').last

    integration = assert_load("apigatewayv2-get-integrations__#{api_id}",'Items')
      .find('IntegrationId',integration_id).returns(:all)

    lambda_arn = assert_json(integration,'IntegrationUri').returns(:all)
    lambda_name = lambda_arn.split(':').last

    lambda_config = assert_load("lambda-get-function__#{lambda_name}",'Configuration').returns(:all)

    assert_json(lambda_config,'Runtime').expects_match('ruby')
    assert_json(lambda_config,'CodeSize').expects_gt(0)
    assert_json(integration,'ConnectionType').expects_eq('INTERNET')
    assert_json(integration,'IntegrationMethod').expects_eq('POST')
    assert_json(integration,'IntegrationType').expects_eq('AWS_PROXY')
    assert_json(route,'AuthorizationType').expects_eq('CUSTOM')
    assert_json(lambda_config,'Environment','Variables','UPLOADS_BUCKET_NAME').expects_eq(bucket_name)

    set_pass_message "Found API Gateway route ruby lambda with custom authorization for POST /avatars/key_upload"
    set_fail_message "Failed to find API Gateway route ruby lambda with custom authorization for POST /avatars/key_upload"
  end

  spec :should_have_proxy_route do |t|
    api_id = specific_params.apigateway_api_id

    route = assert_load("apigatewayv2-get-routes__#{api_id}",'Items').find('RouteKey',"OPTIONS /{proxy+}").returns(:all)

    target_arn = assert_json(route,'Target').returns(:all)
      
    assert_not_nil(target_arn)
    integration_id = target_arn.split('/').last

    integration = assert_load("apigatewayv2-get-integrations__#{api_id}",'Items')
      .find('IntegrationId',integration_id).returns(:all)

    lambda_arn = assert_json(integration,'IntegrationUri').returns(:all)
    lambda_name = lambda_arn.split(':').last

    lambda_config = assert_load("lambda-get-function__#{lambda_name}",'Configuration').returns(:all)
    
    assert_json(route,'AuthorizationType').expects_eq('NONE')
    assert_json(lambda_config,'CodeSize').expects_gt(0)
    assert_json(integration,'ConnectionType').expects_eq('INTERNET')
    assert_json(integration,'IntegrationMethod').expects_eq('POST')
    assert_json(integration,'IntegrationType').expects_eq('AWS_PROXY')
    assert_json(route,'AuthorizationType').expects_eq('NONE')

    set_pass_message "Found API Gateway route OPTIONS /{proxy+"
    set_fail_message "Failed to find API Gateway route OPTIONS /{proxy+"
  end

  spec :should_have_s3_bucket_with_event_notification do |t|
    bucket_name = specific_params.raw_assets_bucket_name
    naked_domain_name = t.specific_params.naked_domain_name

    event = assert_load("s3api-get-bucket-notification-configuration__#{bucket_name}",'LambdaFunctionConfigurations').returns(:first)

    lambda_arn = assert_json(event,'LambdaFunctionArn').returns(:all)
    assert_not_nil(lambda_arn)
    lambda_name = lambda_arn.split(':').last
    lambda_config = assert_load("lambda-get-function__#{lambda_name}",'Configuration').returns(:all)

    dest_bucket = assert_json(lambda_config,'Environment','Variables','DEST_BUCKET_NAME').returns(:all)

    assert_json(lambda_config,'Runtime').expects_match(/nodejs/)
    assert_eq(dest_bucket,"assets.#{naked_domain_name}")
    assert_json(lambda_config,'CodeSize').expects_gt(0)
    
    event = assert_json(event,'Events').returns(:first)
    assert_eq(event,'s3:ObjectCreated:Put')

    set_fail_message "Found raw assets bucket that has an event notification on object put to assets.#{naked_domain_name}"
    set_pass_message "Failed to raw assets bucket that has an event notification on object put to assets.#{naked_domain_name}"
  end

  spec :should_block_public_access_for_assets_bucket do |t|
    naked_domain_name = t.specific_params.naked_domain_name

    access = assert_load("s3api-get-public-access-block__assets.#{naked_domain_name}",'PublicAccessBlockConfiguration').returns(:all)

    assert_json(access,'BlockPublicPolicy').expects_true
    assert_json(access,'RestrictPublicBuckets').expects_true

    set_pass_message "Found s3 static website for assets.#{naked_domain_name} to disallow bucket policies"
    set_fail_message "Failed to find ss3 static website for assets.#{naked_domain_name} to disallow bucket policies"
  end

  spec :should_have_a_cloudfront_distrubition_to_assets do |t|
    assets_domain_name = "assets.#{specific_params.naked_domain_name}"

    items = assert_load('cloudfront-list-distributions','DistributionList').returns('Items')

    distribution =
    assert_find(items) do |assert,distribution|
      aliases = distribution['Aliases']
      assert.expects_eq(aliases,'Quantity',1)
      item = aliases['Items'].first
      assert.expects_eq(item,assets_domain_name)
    end.returns(:all)

    assert_not_nil(distribution)

    domain = assert_json(distribution,'Origins','Items').returns(:first)
    domain_name = assert_json(domain,'DomainName').returns(:all)

    assert_json(distribution,'Status').expects_eq('Deployed')
    assert_json(distribution,'Origins','Quantity').expects_eq(1)
    assert_start_with(domain_name,"#{assets_domain_name}.s3")
    assert_end_with(domain_name,".amazonaws.com")

    dist_id = assert_json(distribution,'Id').returns(:all)
    dist_domain_name = assert_json(distribution,'DomainName').returns(:all)

    set_state_value :assets_distribution_id, dist_id
    set_state_value :assets_distribution_domain_name, dist_domain_name

    set_pass_message "Found CloudFront distrubution with origin to S3 bucket: #{assets_domain_name}.s3.amazonaws.com"
    set_fail_message "Failed to find CloudFront distrubution with origin to S3 bucket: #{assets_domain_name}.s3.amazonaws.com"
  end

  spec :should_have_route53_to_distribution_for_assets do |t|
    naked_domain_name = t.specific_params.naked_domain_name
    assets_domain_name = "assets.#{t.specific_params.naked_domain_name}"
    dist_domain_name = t.dynamic_params.assets_distribution_domain_name
    zone_arn = assert_load('route53-list-hosted-zones','HostedZones').find('Name',"#{naked_domain_name}.").returns('Id')

    assert_not_nil(zone_arn)
    zone_id = zone_arn.split("/").last

    record_sets = assert_load("route53-list-resource-record-sets__#{zone_id}",'ResourceRecordSets').returns(:all)

    record =
    assert_find(record_sets) do |assert,record|
      assert.expects_eq(record,'Name',"#{assets_domain_name}.")
      assert.expects_eq(record,'Type',"A")
    end.returns(:all)

    assert_not_nil(record)
    assert_json(record,'AliasTarget','DNSName').expects_eq("#{dist_domain_name}.")

    set_fail_message "Found route53 assets domain and pointing to the cloudfront distribution for assets"
    set_pass_message "Failed to find a route53 assets domain and pointing to the cloudfront distribution for assets"
  end
end