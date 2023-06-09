require 'active_model'
class Cpbvt::Payloads::Aws::GeneralParams
  include ActiveModel::Validations

  attr_accessor :project_scope,
                :user_uuid,
                :run_uuid,
                :region,
                :user_region,
                :output_path,
                :aws_access_key_id,
                :aws_secret_access_key,
                :payloads_bucket

  validates :project_scope, presence: true
  validates :user_uuid , presence: true
  validates :run_uuid, presence: true
  validates :region, presence: true
  validates :user_region, presence: true
  validates :output_path, presence: true
  validates :aws_access_key_id, presence: true
  validates :aws_secret_access_key, presence: true
  validates :payloads_bucket, presence: true

  def initialize(
    project_scope:,
    user_uuid:,
    run_uuid:,
    region:,
    user_region:,
    output_path:,
    aws_access_key_id:,
    aws_secret_access_key:,
    payloads_bucket:
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
      payloads_bucket: @payloads_bucket
    }
  end
end