require 'fileutils'
require 'ostruct'
require 'time'
require 'open3'

module Cpbvt::Payloads::Gcp::Runner
  def self.run command, general_params, specific_params={}
    starts_at = Time.now.to_f

    # if no filename provided base it on the provided command
    unless general_params[:filename]
      general_params[:filename] = "#{command.gsub('_','-')}.json"
    end
    general_params = OpenStruct.new general_params

    output_file = Cpbvt::Payloads::Gcp::Runner::output_file(
      run_uuid: general_params.run_uuid,
      user_uuid: general_params.user_uuid,
      project_scope: general_params.project_scope,
      gcp_project_id: general_params.gcp_project_id, 
      output_path: general_params.output_path,
      filename: general_params.filename
    )

    command = Cpbvt::Payloads::Gcp::Command.send(command, **specific_params)
    command = command.strip.gsub("\n", " ")
    command = "#{command} --project #{general_params.gcp_project_id}"
    command = "#{command} --format json > #{output_file}"

    #stdout_str should always result in empty 
    #string since its writing to a file
    stdout_str, stderr_str, status =
    Cpbvt::Payloads::Gcp::Runner.execute(
      general_params.run_uuid,
      command
    )

    puts stdout

    # We need to do error handling here

    ends_at = Time.now.to_f
    return {
      id: id,
      params: specific_params,
      benchmark: {
        starts_at: starts_at,
        ends_at:  ends_at,
        duration_in_ms: ((ends_at - starts_at)*1000).to_i
      },
      error: error,
      command: command,
      output_file: output_file
    }
  end

  # create the path to where the json file will be downloaded
  def self.output_file(user_uuid:,run_uuid:,project_scope:,gcp_project_id:,output_path:,filename:)
    value = File.join(
      output_path, 
      project_scope, 
      "user-#{user_uuid}",
      "run-#{run_uuid}",
      gcp_project_id
      filename
    )

    # create the folder for the downloaded json if it doesn't exist
    FileUtils.mkdir_p File.dirname(value)

    # print the desination of the outputed json
    #puts "[Output File] #{value}"

    return value
  end

  def self.execute run_uuid, command
    # print the command so we know what is running
    puts "[Executing] #{command}"
    # run the command which will download the json

    self.broadcast run_uuid, command

    # capture3 returns the follwoing ---
    # stdout_str, stderr_str, status
    Open3.capture3(env_vars, command)
  end

  def self.broadcast run_uuid, command
    #OVERRIDE
  end
end