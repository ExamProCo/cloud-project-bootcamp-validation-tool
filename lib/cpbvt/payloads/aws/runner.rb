require 'fileutils'
require 'ostruct'
require 'time'
require 'open3'


module Cpbvt::Payloads::Aws::Runner
  def self.run command, general_params, specific_params={}
    starts_at = Time.now.to_f

    # if no filename provided base it on the provided command
    unless general_params[:filename]
      general_params[:filename] = "#{command.gsub('_','-')}.json"
    end
    general_params = OpenStruct.new general_params

    output_file = Cpbvt::Payloads::Aws::Runner::output_file(
      run_uuid: general_params.run_uuid,
      user_uuid: general_params.user_uuid,
      project_scope: general_params.project_scope,
      region: general_params.user_region, 
      output_path: general_params.output_path,
      filename: general_params.filename
    )

    #object_key = Cpbvt::Uploader::object_key(
    #  user_uuid: general_params.user_uuid,
    #  run_uuid: general_params.run_uuid,
    #  project_scope: general_params.project_scope,
    #  region: general_params.user_region, 
    #  filename: general_params.filename
    #)

    command = Cpbvt::Payloads::Aws::Command.send(command, **specific_params)
    command = command.strip.gsub("\n", " ")
    command = "#{command} --region #{general_params.user_region}" unless general_params.user_region == 'global'
    command = "#{command} --output json > #{output_file}"

    general_params.tmp_aws_access_key_id

    #stdout_str should always result in empty 
    #string since its writing to a file
    stdout_str, stderr_str, status =
    Cpbvt::Payloads::Aws::Runner.execute(
      general_params.run_uuid,
      general_params.tmp_aws_access_key_id,
      general_params.tmp_aws_secret_access_key,
      general_params.tmp_aws_session_token,
      command
    )
    # upload json file to s3
    #Cpbvt::Uploader.run(
    #  file_path: output_file,
    #  object_key: object_key,
    #  aws_region: attrs.region,
    #  aws_access_key_id: attrs.aws_access_key_id,
    #  aws_secret_access_key: attrs.aws_secret_access_key,
    #  payloads_bucket: attrs.payloads_bucket
    #)

    id = general_params.filename.sub(".json","")

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
  end # run

  # This was a failed attmpt for pulling for a more complex
  # API call that requires two parameters to fetch the data.
  # Since most API calls only require one, it didn't makes sense
  # to implement this yet until I saw more emergin edge cases.
  #{
  #  command: 'cognito_idp_describe_user_pool_client',
  #  params: {
  #    user_pool_id: 'cognito_idp_list_user_pools',
  #    client_id: 'cognito_idp_list_user_pool_clients'
  #  }
  #def self.iter_params(
  #    manifest:, 
  #    command:, 
  #    specific_params:, 
  #    general_params:
  #  )
  #  results = []
  #  keys = specific_params.keys

  #  specific_params.each_with_index do |param, data_key|

  #    prev_param = nil

  #    # how many params are there
  #    len = keys.index(param)

  #    unless keys.index(param).zero?
  #      prev_param = keys[keys.index(param)-1]
  #    end

  #    results = Cpbvt::Payloads::Aws::Runner.iter_run!(
  #      manifest: manifest,
  #      command: data_key,
  #      param: param,
  #      general_params: general_params
  #    )

  #    results.each do |t|
  #      # appending the results to our results
  #      results = results + Cpbvt::Payloads::Aws::Runner.iter_run!(
  #        manifest: manifest,
  #        command: data_key,
  #        param: param,
  #        general_params: general_params
  #      )
  #    end # results.each

  #  end

  #  results.each do |t|
  #    manifest.add_payload t[0], t[1]
  #  end # results.each
  #end
  # ------

  # Iterrun will take a a file and iterate over every single resource to further describe it.
  # When we have an AWS API Call that needs a specific value from a list of resources.
  # eg. in order to get describe_user_pool we have to extract the user_pool_ids from list_user_pools
  def self.iter_run!(
      manifest:,
      command:,
      specific_params:,
      general_params:,
      extractor_filters: {}
    )
    # all the results from the command being run
    results = []

    # harcoded to only work with one param until
    # we know how to support multiple nested params
    param, data_key = specific_params.first

    unless general_params[:filename]
      general_params[:filename] = "#{command.gsub('_','-')}.json"
    end

    # automatically pull the other required data if it is not already loaded
    unless manifest.has_payload?(data_key.to_s)
      parent_filename = "#{data_key.gsub('_','-')}.json"
      result = Cpbvt::Payloads::Aws::Runner.run(
        data_key,
        general_params.merge({filename: parent_filename}),
      )
      manifest.add_payload data_key, result
    end

    # load the local data
    data = manifest.get_output data_key

    # extract the data from the local file that we'll use to iterate
    iter_data = Cpbvt::Payloads::Aws::Extractor.send(
      "#{data_key}__#{param}",
      data,
      extractor_filters
    )
    unless iter_data.nil?
      iter_data.each do |extractor_attrs|
        # we don't want to pass the iter_id to the command
        # but we do want to use it to identify this specific record
        iter_id = extractor_attrs.delete(:iter_id)

        # add in the identifier into the filename
        filename = general_params[:filename].sub(".json","__#{iter_id}.json")

        # run the command as per usual
        result = Cpbvt::Payloads::Aws::Runner.run(
          command,
          general_params.merge({filename: filename}),
          extractor_attrs
        )
        results.push result
      end # iter_data.each
    end
    return results
  end # def self.iter_run!

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
    #puts "[Output File] #{value}"

    return value
  end

  def self.execute run_uuid, key, secret, session_token, command
    if key.nil? || secret.nil? || session_token.nil?
      raise 'creds are nil'
    end
    # print the command so we know what is running
    puts "[Executing] #{command}"
    # run the command which will download the json

    self.broadcast run_uuid, command

    env_vars = {
      "AWS_ACCESS_KEY_ID" => key,
      "AWS_SECRET_ACCESS_KEY" => secret,
      "AWS_SESSION_TOKEN" => session_token
    }
    # capture3 returns the follwoing ---
    # stdout_str, stderr_str, status
    Open3.capture3(env_vars, command)
  end
  # Create Ostruct and validate general params

  def self.broadcast run_uuid, command
    #OVERRIDE
  end
end
