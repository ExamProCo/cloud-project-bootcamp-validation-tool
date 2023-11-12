require 'async'

class Azure::Puller
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

    creds = Cpbvt::Payloads::Azure::Command.login(
      general_params.azure_client_id, 
      general_params.azure_client_secret, 
      general_params.azure_tenant_id
    )
    account_name = specific_params.storage_account_name
    container_name = specific_params.storage_container_name
    blob_name = specific_params.storage_blob_name
    xblob_name = File.basename(blob_name, File.extname(blob_name))
    Async do |task|
      self.pull_async task, :az_storage_account_list, manifest, general_params

      self.pull_async(task,
        :az_storage_container_list, 
        manifest, 
        general_params.to_h.merge({
          filename: "#{:az_storage_container_list.to_s.gsub('_','-')}__#{account_name}.json",
        }),
        {account_name: account_name }
      )
      self.pull_async(task, 
        :az_storage_blob_exists, 
        manifest, 
        general_params.to_h.merge({
          filename: "#{:az_storage_blob_exists.to_s.gsub('_','-')}__#{account_name}__#{container_name}__#{xblob_name}.json",
        }),
        {account_name: account_name, container_name: specific_params.storage_container_name, blob_name: blob_name }
      )
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
    general_params = general_params.to_h unless general_params.is_a?(Hash)
    result = Cpbvt::Payloads::Azure::Runner.run(
      command.to_s, 
      general_params,
      specific_params
    )
    manifest.add_payload result[:id], result
  end
end