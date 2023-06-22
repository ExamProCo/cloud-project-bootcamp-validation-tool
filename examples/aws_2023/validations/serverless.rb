class Aws2023::Validations::Serverless

  def self.should_have_key_upload_route(manifest:,specific_params:)
    api_id = specific_params.apigateway_api_id

    data = manifest.get_output("apigatewayv2-get-routes__#{api_id}")['Items']

    route = 
    data.find do |t|
      t['RouteKey'] == "POST /avatars/key_upload"
    end

    integration_id = route['Target'].split('/').last

    integration_data = manifest.get_output("apigatewayv2-get-integrations__#{api_id}")['Items']
    integration = integration_data.find{|t| t['IntegrationId'] == integration_id }

    lambda_arn = integration['IntegrationUri']
    lambda_name = lambda_arn.split(':').last

    lambda_data = manifest.get_output("lambda-get-function__#{lambda_name}")['Configuration']

    bucket_name = specific_params.raw_assets_bucket_name

    checks = {
      runtime: !!lambda_data['Runtime'].match('ruby'),
      codesize: lambda_data['CodeSize'] > 0,
      connecetion_type: integration['ConnectionType'] == 'INTERNET',
      post: integration['IntegrationMethod'] == 'POST',
      integration_type: integration['IntegrationType'] == 'AWS_PROXY',
      authorization_type: route['AuthorizationType'] == 'CUSTOM',
      env_var_bucket: lambda_data['Environment']['Variables']['UPLOADS_BUCKET_NAME'] == bucket_name
    }
    found = checks.values.all?

    if found
      score = 10
      message = "Found API Gateway route ruby lambda with custom authorization for POST /avatars/key_upload"
    else
      score = 0
      message = "Failed to find API Gateway route ruby lambda with custom authorization for POST /avatars/key_upload"
    end

    return {
      result: {
        score: score,
        message: message,
        checks: checks
      }
    }
  end

  def self.should_have_proxy_route(manifest:,specific_params:)
    api_id = specific_params.apigateway_api_id
    data = manifest.get_output("apigatewayv2-get-routes__#{api_id}")['Items']

    route = 
    data.find do |t|
      t['RouteKey'] == "OPTIONS /{proxy+}"
    end

    integration_id = route['Target'].split('/').last

    integration_data = manifest.get_output("apigatewayv2-get-integrations__#{api_id}")['Items']
    integration = integration_data.find{|t| t['IntegrationId'] == integration_id }

    lambda_arn = integration['IntegrationUri']
    lambda_name = lambda_arn.split(':').last
    lambda_data = manifest.get_output("lambda-get-function__#{lambda_name}")['Configuration']
    
    checks = {
      authorization_type: route['AuthorizationType'] == 'None',
      code_size: lambda_data['CodeSize'] > 0,
      connection_type: integration['ConnectionType'] == 'INTERNET',
      integration_method: integration['IntegrationMethod'] == 'POST',
      integration_Type: integration['IntegrationType'] == 'AWS_PROXY',
      authorization_type: route['AuthorizationType'] == 'NONE'
    }
    found = checks.values.all?

    if found
      score = 10
      message = "Found API Gateway route OPTIONS /{proxy+"
    else
      score = 0
      message = "Failed to find API Gateway route OPTIONS /{proxy+"
    end

    return {
      result: {
        score: score,
        message: message,
        checks: checks
      }
    }
  end

  def self.should_have_s3_bucket_with_event_notification(manifest:,specific_params:)
    bucket_name = specific_params.raw_assets_bucket_name

    data = manifest.get_output!("s3api-get-bucket-notification-configuration__#{bucket_name}")

    event = data['LambdaFunctionConfigurations'].first

    lambda_arn = event['LambdaFunctionArn']
    lambda_name = lambda_arn.split(':').last
    lambda_data = manifest.get_output("lambda-get-function__#{lambda_name}")['Configuration']

    dest_bucket = lambda_data['Environment']['Variables']['DEST_BUCKET_NAME']

    checks = {
      runtime: !!lambda_data['Runtime'].match(/nodejs/),
      env_var_bucket: dest_bucket == "assets.#{specific_params.naked_domain_name}",
      codesize: lambda_data['CodeSize'] > 0,
      put_event: event['Events'].first['s3:ObjectCreated:Put']
    }
    found = checks.values.all?

    if found
      score = 10
      message = "Found raw assets bucket that has an event notification on object put to assets.#{specific_params.naked_domain_name}" 
    else
      score = 0
      message = "Failed to raw assets bucket that has an event notification on object put to assets.#{specific_params.naked_domain_name}" 
    end

    return {
      result: {
        score: score,
        message: message,
        checks: checks
      }
    }
  end

  def self.should_block_public_access_for_assets_bucket(manifest:,specific_params:)
    naked_domain_name = specific_params.naked_domain_name

    access = manifest.get_output!("s3api-get-public-access-block__assets.#{naked_domain_name}")

    found =
    access['PublicAccessBlockConfiguration']['BlockPublicPolicy'] == true &&
    access['PublicAccessBlockConfiguration']['RestrictPublicBuckets'] == true

    if found
      {result: {score: 10, message: "Found s3 static website for assets.#{naked_domain_name} to disallow bucket policies"}}
    else
      {result: {score: 0, message: "Failed to find ss3 static website for assets.#{naked_domain_name} to disallow bucket policies"}}
    end
  end

  def self.should_have_a_cloudfront_distrubition_to_assets(manifest:,specific_params:)
    assets_domain_name = "assets.#{specific_params.naked_domain_name}"

    data = manifest.get_output!('cloudfront-list-distributions')

    distribution =
    data['DistributionList']['Items'].find do |distribution|
      distribution['Aliases']['Quantity'] == 1 &&
      distribution['Aliases']['Items'].first == assets_domain_name
    end

    domain_name = distribution['Origins']['Items'].first['DomainName']
    checks = {
      status: distribution['Status'] == 'Deployed',
      qauntity: distribution['Origins']['Quantity'] == 1,
      domain_name_starts: domain_name.start_with?("#{assets_domain_name}.s3"),
      domain_name_ends: domain_name.end_with?(".amazonaws.com")
    }
    found = checks.values.all?

    dist_id = distribution['Id']
    dist_domain_name = distribution['DomainName']

    if found
      score = 10
      message = "Found CloudFront distrubution with origin to S3 bucket: #{assets_domain_name}.s3.amazonaws.com"
    else
      score = 0
      message = "Failed to find CloudFront distrubution with origin to S3 bucket: #{assets_domain_name}.s3.amazonaws.com"
    end

    return {
        result: {
          score: score,
          message: message,
          checks: checks
        },
        assets_distribution_id: dist_id,
        assets_distribution_domain_name: dist_domain_name
      }
  end

  def self.should_have_route53_to_distribution_for_assets(manifest:,specific_params:,assets_distribution_domain_name:)
    naked_domain_name = specific_params.naked_domain_name
    assets_domain_name = "assets.#{specific_params.naked_domain_name}"

    data = manifest.get_output!('route53-list-hosted-zones')

    zone =
    data['HostedZones'].find do |zone|
      zone['Name'] == "#{naked_domain_name}."
    end

    zone_id = zone['Id'].split("/").last

    zone_data = manifest.get_output!("route53-list-resource-record-sets__#{zone_id}")

    record =
    zone_data['ResourceRecordSets'].find do |record|
      record['Name'] == "#{assets_domain_name}." &&
      record['Type'] == "A"
    end

    checks = {
      dnsname:  record['AliasTarget']['DNSName'] == "#{assets_distribution_domain_name}."
    }
    found = checks.values.all?

    if found
      score = 10
      message =  "Found route53 assets domain and pointing to the cloudfront distribution for assets"
    else
      score = 0
      message =  "Failed to find a route53 assets domain and pointing to the cloudfront distribution for assets"
    end

    return {
      result: {
        score: score,
        message: message,
        checks: checks
      }
    }
  end  
end