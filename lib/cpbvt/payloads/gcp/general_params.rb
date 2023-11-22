require 'active_model'
class Cpbvt::Payloads::Gcp::GeneralParams
  include ActiveModel::Validations

  # source_aws_account_id = the account that we will upload payload data
  attr_accessor :project_scope,
                :user_uuid,
                :run_uuid,
                :region,
                :output_path,
                :aws_access_key_id,
                :aws_secret_access_key,
                :gcp_key_file,
                :gcp_project_id,
                :tmp_aws_session_token,
                :payloads_bucket,
                :source_aws_account_id

  # we aren't validating the session_token since
  # will pul it after validation

  validates :project_scope, presence: true
  validates :user_uuid , presence: true
  validates :run_uuid, presence: true
  validates :region, presence: true
  validates :output_path, presence: true
  validates :aws_access_key_id, presence: true
  validates :aws_secret_access_key, presence: true
  validates :gcp_key_file, presence: true
  validates :gcp_project_id, presence: true
  validates :payloads_bucket, presence: true
  validates :source_aws_account_id, presence: true

  def initialize(
    project_scope:,
    user_uuid:,
    run_uuid:,
    region:,
    gcp_key_file:,
    gcp_project_id:,
    output_path:,
    aws_access_key_id:,
    aws_secret_access_key:,
    payloads_bucket:,
    source_aws_account_id:
  )
    @project_scope = project_scope
    @run_uuid = run_uuid
    @user_uuid = user_uuid
    @region = region
    @gcp_key_file = gcp_key_file
    @gcp_project_id = gcp_project_id
    @output_path = output_path
    @aws_access_key_id = aws_access_key_id
    @aws_secret_access_key = aws_secret_access_key
    @payloads_bucket = payloads_bucket
    @source_aws_account_id = source_aws_account_id
  end

  # to hash
  def to_h
    {
      project_scope: @project_scope,
      run_uuid: @run_uuid,
      user_uuid: @user_uuid,
      region: @region,
      gcp_key_file: @gcp_key_file,
      gcp_project_id: @gcp_project_id,
      output_path: @output_path,
      aws_access_key_id: @aws_access_key_id,
      aws_secret_access_key: @aws_secret_access_key,
      payloads_bucket: @payloads_bucket,
      source_aws_account_id: @source_aws_account_id,
    }
  end
end
