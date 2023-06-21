class Aws2023::Validations::Authenication
  def self.should_have_cognito_user_pool(manifest:,specific_params:)
    name = specific_params.cognito_user_pool_name

    data_pools = manifest.get_output!("cognito-idp-list-user-pools")
    pool = data_pools['UserPools'].find{|t| t['Name'] == name }
    pool_id = pool['Id']

    data = manifest.get_output!("cognito-idp-describe-user-pool__#{pool_id}")['UserPool']
    
    found = data['EstimatedNumberOfUsers'] > 0

    if found
      {result: {score: 10, message: "Found user pool: #{name} with some users in it"}}
    else
      {result: {score: 0, message: "Failed to find a user pool: #{name} with some users in it"}}
    end
  end

  def self.should_have_trigger_on_post_confirmation(manifest:,specific_params:,vpc_id:)
    name = specific_params.cognito_user_pool_name

    data_pools = manifest.get_output!("cognito-idp-list-user-pools")
    pool = data_pools['UserPools'].find{|t| t['Name'] == name }
    pool_id = pool['Id']

    data = manifest.get_output!("cognito-idp-describe-user-pool__#{pool_id}")['UserPool']

    if lambda_arn = data['LambdaConfig'].key?('PostConfirmation')
      lambda_name = data['LambdaConfig']['PostConfirmation'].split(':').last
    end

    lambda_data = manifest.get_output("lambda-get-function__#{lambda_name}")['Configuration']

    found =
    lambda_data['Runtime'].match('python3') &&
    lambda_data['CodeSize'] > 0
    lambda_data['VpcConfig']['VpcId'] == vpc_id

    if found
      {result: {score: 10, message: "Found a Congnito post confirmation python lambda in the custom VPC"}}
    else
      {result: {score: 0, message: "Failed to find a Cognito post confirmation python lambda in the custom VPC"}}
    end
  end
end