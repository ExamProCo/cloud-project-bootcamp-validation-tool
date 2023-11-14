require 'active_model'
class Cpbvt::Payloads::Azure::GeneralParams
  include ActiveModel::Validations

  # source_aws_account_id = the account that we will upload payload data
  attr_accessor :project_scope,
                :user_uuid,
                :run_uuid,
                :region,
                :output_path,
                :aws_access_key_id,
                :aws_secret_access_key,
                :azure_client_id,
                :azure_tenant_id,
                :azure_client_secret,
                :tmp_aws_session_token,
                :payloads_bucket,
                :target_subscription_id,
                :target_resource_group,
                :source_aws_account_id,
                :external_id

  # we aren't validating the session_token since
  # will pul it after validation

  validates :external_id, presence: true
  validates :project_scope, presence: true
  validates :user_uuid , presence: true
  validates :run_uuid, presence: true
  validates :region, presence: true
  validates :output_path, presence: true
  validates :aws_access_key_id, presence: true
  validates :aws_secret_access_key, presence: true

  validates :azure_client_id, presence: true
  validates :azure_tenant_id, presence: true
  validates :azure_client_secret, presence: true

  validates :target_subscription_id, presence: true
  validates :target_resource_group, presence: true

  validates :payloads_bucket, presence: true
  validates :source_aws_account_id, presence: true

  def initialize(
    project_scope:,
    user_uuid:,
    run_uuid:,
    region:,
    azure_client_id:,
    azure_tenant_id:,
    azure_client_secret:,
    output_path:,
    aws_access_key_id:,
    aws_secret_access_key:,
    payloads_bucket:,
    source_aws_account_id:,
    target_subscription_id:,
    target_resource_group:,
    external_id:
  )
    @project_scope = project_scope
    @run_uuid = run_uuid
    @user_uuid = user_uuid
    @region = region
    @azure_client_id = azure_client_id
    @azure_tenant_id = azure_tenant_id
    @azure_client_secret = azure_client_secret
    @output_path = output_path
    @aws_access_key_id = aws_access_key_id
    @aws_secret_access_key = aws_secret_access_key
    @payloads_bucket = payloads_bucket
    @source_aws_account_id = source_aws_account_id
    @target_subscription_id = target_subscription_id
    @target_resource_group = target_resource_group
    @external_id = external_id
  end

  # to hash
  def to_h
    {
      project_scope: @project_scope,
      run_uuid: @run_uuid,
      user_uuid: @user_uuid,
      region: @region,
      azure_client_id: @azure_client_id,
      azure_tenant_id: @azure_tenant_id,
      azure_client_secret: @azure_client_secret,
      output_path: @output_path,
      aws_access_key_id: @aws_access_key_id,
      aws_secret_access_key: @aws_secret_access_key,
      payloads_bucket: @payloads_bucket,
      source_aws_account_id: @source_aws_account_id,
      target_subscription_id: @target_subscription_id,
      target_resource_group: @target_resource_group,
      external_id: @external_id
    }
  end
end
