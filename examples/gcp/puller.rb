require 'async'

class Gcp::Puller
  def self.run(general_params:,specific_params:)
    unless general_params.valid?
      puts general_params.errors.full_messages
      raise "failed to pass general params validation"
    end

    unless specific_params.valid?
      puts specific_params.errors.full_messages
      raise "failed to specific params validation"
    end

    manifest = Cpbvt::Manifest.new(
      user_uuid: general_params.user_uuid, 
      run_uuid: general_params.run_uuid, 
      project_scope: general_params.project_scope,
      output_path: general_params.output_path,
      payloads_bucket: general_params.payloads_bucket
    )

    creds = Cpbvt::Payloads::Gcp::Command.login general_params.gcp_key_file

    Async do |task|
      self.pull_async task, :gcloud_storage_buckets_list, manifest, general_params
      self.pull_async task, :gcloud_storage_objects_describe, manifest, general_params, {bucket_name: specific_params.gcp_bucket_name, object_name: 'ships.csv' }
    end

    manifest.write_file!
    manifest.archive!

    Cpbvt::Uploader.run(
      file_path: manifest.output_file, 
      object_key: manifest.object_key,
      aws_region: general_params.region,
      aws_access_key_id: general_params.aws_access_key_id,
      aws_secret_access_key: general_params.aws_secret_access_key,
      payloads_bucket: general_params.payloads_bucket
    )
  end

  def self.pull_async(task,command,manifest,general_params,specific_params={})
    task.async do
      self.pull(command,manifest,general_params,specific_params)
    end
  end

  def self.pull(command,manifest,general_params,specific_params={})
    result = Cpbvt::Payloads::Gcp::Runner.run(
      command.to_s, 
      general_params.to_h,
      specific_params
    )
    manifest.add_payload result[:id], result
  end
end