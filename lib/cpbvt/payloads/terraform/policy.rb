require 'fileutils'
require 'json'

class Cpbvt::Payloads::Terraform::Policy
  # permissions are delegated at the resource group level
  # only Reader role permissions are delegated by default 
  def self.generate! general_params
    path = File.join(
      File.dirname(File.expand_path(__FILE__)),
        "organization.tf"
    )

    file = File.read(path)
    org = file.gsub(/\$\{UserOrgName\}/, "#{general_params.terraform_organization}")
    new_file = org.gsub(/\$\{UserWorkspaceName\}/, "#{general_params.terraform_workspace}")
    
    # backend template for terraform goes in run specific folder to avoid
    # conflicts with multiple terraform templates in the same folder during initialization
    output_path = File.join(
      general_params.output_path,
      general_params.project_scope,
      "user-#{general_params.user_uuid}",
      "run-#{general_params.run_uuid}",
      "organization.tf"
    )

    dirpath = File.dirname output_path
    FileUtils.mkdir_p(dirpath)

    File.open(output_path, 'w') do |f|
      f.write(new_file)
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

    return object_key
  end
end