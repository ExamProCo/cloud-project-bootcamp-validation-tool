require 'fileutils'
require 'json'

class Cpbvt::Payloads::Azure::Policy
  # permissions are delegated at the resource group level
  # only Reader role permissions are delegated by default 
  def self.generate! general_params
    path = File.join(
      File.dirname(File.expand_path(__FILE__)),
        "lighthouse-template.json"
    )

    file = File.read(path)
    arm_template = JSON.parse(file)  
    arm_template['parameters']['rgName']['defaultValue'] = "#{general_params.target_resource_group}"

    output_path = File.join(
      general_params.output_path,
      general_params.project_scope,
      "user-#{general_params.user_uuid}",
      "#{general_params.run_uuid}-lighthouse-template.json"
    )

    dirpath = File.dirname output_path
    FileUtils.mkdir_p(dirpath)

    File.open(output_path, 'w') do |f|
      f.write(arm_template.to_json)
    end

    object_key = Cpbvt::Uploader.object_key(
      user_uuid: general_params.user_uuid,
      project_scope: general_params.project_scope,
      run_uuid: general_params.run_uuid,
      region: general_params.region,
      filename: File.basename(output_path)
    )
    Cpbvt::Uploader.run(
      file_path: output_path,
      object_key: object_key,
      aws_region: general_params.region,
      aws_access_key_id: general_params.aws_access_key_id,
      aws_secret_access_key: general_params.aws_secret_access_key,
      payloads_bucket: general_params.payloads_bucket,
      public_read: true
    )
    File.delete(output_path) if File.exist?(output_path)

    return object_key
  end
end