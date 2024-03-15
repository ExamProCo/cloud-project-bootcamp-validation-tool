require 'fileutils'
require 'ostruct'
require 'time'
require 'open3'

module Cpbvt::Payloads::Terraform::Runner
  def self.run command, general_params, specific_params={}
    starts_at = Time.now.to_f

    # if no filename provided base it on the provided command
    unless general_params[:filename]
      general_params[:filename] = "#{command.gsub('_','-')}.json"
    end
    general_params = OpenStruct.new general_params

    output_file = Cpbvt::Payloads::Terraform::Runner::output_file(
      run_uuid: general_params.run_uuid,
      user_uuid: general_params.user_uuid,
      project_scope: general_params.project_scope,
      output_path: general_params.output_path,
      filename: general_params.filename
    )

    specific_params[:terraform_token] = general_params["terraform_token"]
    command = Cpbvt::Payloads::Terraform::Command.send(command, **specific_params)
    command = command.strip.gsub("\n", " ")
    command = "#{command} > #{general_params.filename}"

    stdout_str, stderr_str, status =
    Cpbvt::Payloads::Terraform::Runner.execute(
      general_params.run_uuid,
      command,
      general_params.terraform_token
    )

    puts stdout_str

    id = general_params.filename.sub(".json","")

    error = false
    error = stderr_str.strip if stderr_str != ""
    if error == false && File.size?(output_file).nil?
      error = "No data returned"
    end

    error = false
    error = stderr_str.strip if stderr_str != ""
    if error == false && File.size?(output_file).nil?
      error = "No data returned"
    end

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
  def self.output_file(user_uuid:,run_uuid:,project_scope:,output_path:,filename:)
    value = File.join(
      output_path, 
      project_scope, 
      "user-#{user_uuid}",
      "run-#{run_uuid}",
      filename
    )

    # create the folder for the downloaded json if it doesn't exist
    FileUtils.mkdir_p File.dirname(value)

    # print the desination of the outputed json
    #puts "[Output File] #{value}"

    return value
  end

  def self.execute run_uuid, command, terraform_token
    # print the command so we know what is running
    puts "[Executing] #{command}"
    self.broadcast run_uuid, "terraform state pull (remote)"

    env_vars = {
      'TERRAFORM_TOKEN' => terraform_token
    }

    # capture3 returns the follwoing ---
    # stdout_str, stderr_str, status
    Open3.capture3(env_vars, command)
  end

  def self.broadcast run_uuid, command
    #OVERRIDE
  end
end