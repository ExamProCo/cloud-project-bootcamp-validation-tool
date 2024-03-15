require 'active_model'
class Cpbvt::Payloads::Terraform::GeneralParams
  include ActiveModel::Validations

  # source_aws_account_id = the account that we will upload payload data
  attr_accessor :project_scope,
                :user_uuid,
                :run_uuid,
                :region,
                :output_path,
                :aws_access_key_id,
                :aws_secret_access_key,
                :tmp_aws_session_token,
                :payloads_bucket,
                :source_aws_account_id,
                :terraform_token,
                :terraform_organization,
                :terraform_workspace

  validates :project_scope, presence: true
  validates :user_uuid , presence: true
  validates :run_uuid, presence: true
  validates :region, presence: true
  validates :output_path, presence: true
  validates :aws_access_key_id, presence: true
  validates :aws_secret_access_key, presence: true
  validates :payloads_bucket, presence: true
  validates :source_aws_account_id, presence: true
  validates :terraform_token, presence: true
  validates :terraform_organization, presence: true
  validates :terraform_workspace, presence: true

  def initialize(
    project_scope:,
    user_uuid:,
    run_uuid:,
    region:,
    output_path:,
    aws_access_key_id:,
    aws_secret_access_key:,
    payloads_bucket:,
    source_aws_account_id:,
    terraform_token:,
    terraform_organization:,
    terraform_workspace:
  )
    @project_scope = project_scope
    @run_uuid = run_uuid
    @user_uuid = user_uuid
    @region = region
    @output_path = output_path
    @aws_access_key_id = aws_access_key_id
    @aws_secret_access_key = aws_secret_access_key
    @payloads_bucket = payloads_bucket
    @source_aws_account_id = source_aws_account_id
    @terraform_token = terraform_token
    @terraform_organization = terraform_organization
    @terraform_workspace = terraform_workspace
  end

  # to hash
  def to_h
    {
      project_scope: @project_scope,
      run_uuid: @run_uuid,
      user_uuid: @user_uuid,
      region: @region,
      output_path: @output_path,
      aws_access_key_id: @aws_access_key_id,
      aws_secret_access_key: @aws_secret_access_key,
      payloads_bucket: @payloads_bucket,
      source_aws_account_id: @source_aws_account_id,
      terraform_token: @terraform_token,
      terraform_organization: @terraform_organization,
      terraform_workspace: @terraform_workspace
    }
  end
end
