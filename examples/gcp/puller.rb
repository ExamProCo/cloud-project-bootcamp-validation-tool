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
      self.pull_async task, primary_region, :gcloud_storage_ls, manifest, general_params, {bucket_name: specific_params.bucket_name }
    end
  end

  def self.pull_async(task,command,manifest,general_params,specific_params={})
    task.async do
      self.pull(command,manifest,general_params,specific_params)
    end
  end

  def self.pull(command,manifest,general_params,specific_params={})
    result = Cpbvt::Payloads::Gcp::Runner.run(
      command.to_s, 
      general_params,
      specific_params
    )
    manifest.add_payload result[:id], result
  end
end