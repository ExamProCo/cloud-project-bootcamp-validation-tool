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
      runtime: lambda_data['Runtime'].match('ruby'),
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

  def should_have_s3_bucket(manifest:,specific_params:)
    
  end


end