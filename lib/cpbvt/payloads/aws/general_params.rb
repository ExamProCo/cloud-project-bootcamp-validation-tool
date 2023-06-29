require 'active_model'
class Cpbvt::Payloads::Aws::GeneralParams
  include ActiveModel::Validations

  # target_aws_account_id = bootcamper's account
  # source_aws_account_id = the account checking the bootcamper account
  attr_accessor :project_scope,
                :user_uuid,
                :run_uuid,
                :region,
                :user_region,
                :output_path,
                :aws_access_key_id,
                :aws_secret_access_key,
                :session_token,
                :payloads_bucket,
                :target_aws_account_id,
                :source_aws_account_id

  # we aren't validating the session_token since
  # will pul it after validation

  validates :project_scope, presence: true
  validates :user_uuid , presence: true
  validates :run_uuid, presence: true
  validates :region, presence: true
  validates :user_region, presence: true
  validates :output_path, presence: true
  validates :aws_access_key_id, presence: true
  validates :aws_secret_access_key, presence: true
  validates :payloads_bucket, presence: true
  validates :target_aws_account_id, presence: true
  validates :source_aws_account_id, presence: true

  def initialize(
    project_scope:,
    user_uuid:,
    run_uuid:,
    region:,
    user_region:,
    output_path:,
    aws_access_key_id:,
    aws_secret_access_key:,
    payloads_bucket:,
    target_aws_account_id:,
    source_aws_account_id:
  )
    @project_scope = project_scope
    @run_uuid = run_uuid
    @user_uuid = user_uuid
    @region = region
    @user_region = user_region
    @output_path = output_path
    @aws_access_key_id = aws_access_key_id
    @aws_secret_access_key = aws_secret_access_key
    @payloads_bucket = payloads_bucket
    @target_aws_account_id = target_aws_account_id
    @source_aws_account_id = source_aws_account_id
  end

  # to hash
  def to_h
    {
      project_scope: @project_scope,
      run_uuid: @run_uuid,
      user_uuid: @user_uuid,
      region: @region,
      user_region: @user_region,
      output_path: @output_path,
      aws_access_key_id: @aws_access_key_id,
      aws_secret_access_key: @aws_secret_access_key,
      payloads_bucket: @payloads_bucket,
      target_aws_account_id: @target_aws_account_id,
      source_aws_account_id: @source_aws_account_id
    }
  end
end