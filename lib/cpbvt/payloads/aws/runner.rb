require 'fileutils'
require 'ostruct'
require 'time'


module Cpbvt::Payloads::Aws::Runner
  def self.run command, attrs
    starts_at = Time.now.to_i
    attrs = OpenStruct.new attrs
    output_file = Cpbvt::Payloads::Aws::Runner::output_file(
      run_uuid: attrs.run_uuid,
      user_uuid: attrs.user_uuid,
      project_scope: attrs.project_scope,
      region: attrs.user_region, 
      output_path: attrs.output_path,
      filename: attrs.filename
    )

    object_key = Cpbvt::Uploader::object_key(
      user_uuid: attrs.user_uuid,
      run_uuid: attrs.run_uuid,
      project_scope: attrs.project_scope,
      region: attrs.user_region, 
      filename: attrs.filename
    )

    command = Cpbvt::Payloads::Aws::Commands.send(
      command,
      output_file: output_file,
      region: attrs.user_region
    )

    Cpbvt::Payloads::Aws::Runner.execute command
    # upload json file to s3
    Cpbvt::Uploader.run(
      file_path: output_file, 
      object_key: object_key,
      aws_region: attrs.region,
      aws_access_key_id: attrs.aws_access_key_id,
      aws_secret_access_key: attrs.aws_secret_access_key,
      payloads_bucket: attrs.payloads_bucket
    )

    ends_at = Time.now.to_i
    {
      benchmark: {
        starts_at: starts_at,
        ends_at:  ends_at,
        duration_in_seconds: ends_at - starts_at
      },
      command: command,
      object_key: object_key
    }
  end

  # create the path to where the json file will be downloaded
  def self.output_file(user_uuid:, 
                       run_uuid:,
                       project_scope:,
                       region:,
                       output_path:,
                       filename:)
    value = File.join(
      output_path, 
      project_scope, 
      "user-#{user_uuid}",
      "run-#{run_uuid}",
      region, 
      filename
    )

    # create the folder for the downloaded json if it doesn't exist
    FileUtils.mkdir_p File.dirname(value)

    # print the desination of the outputed json
    puts "[Output File] #{value}"

    return value
  end

  def self.execute command
    # print the command so we know what is running
    puts "[Executing] #{command}"
    # run the command which will download the json
    system command
  end
end