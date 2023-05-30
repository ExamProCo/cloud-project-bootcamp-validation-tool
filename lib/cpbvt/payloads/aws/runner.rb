require 'fileutils'
require 'ostruct'
require 'time'


module Cpbvt::Payloads::Aws::Runner
  def self.run command, attrs, params={}
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

    command = Cpbvt::Payloads::Aws::Commands.send(command, **params)
    command = command.strip.gsub("\n", " ")
    command = "#{command} --region #{attrs.user_region}" unless attrs.user_region == 'global'
    command = "#{command} --output json > #{output_file}"
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
    return {
      params: params,
      benchmark: {
        starts_at: starts_at,
        ends_at:  ends_at,
        duration_in_seconds: ends_at - starts_at
      },
      command: command,
      object_key: object_key,
      output_file: output_file
    }
  end # run

  # When we have an AWS API Call that needs a specific value from a list of resources.
  # eg. in order to get describe_user_pool we have to extract the user_pool_ids from list_user_pools

  # data_key - eg. acm_list_certificates
  # formatter - the name of the function that will format the loaded data
  def self.iter_run! manifest:, command:, specific_params:, general_params:
    # all the results from the command being run
    results = []

    specific_params.each_with_index do |data_key, extractor|

      # automatically pull the other required data if it is not already loaded
      unless manifest.has_payload?(data_key.to_s)
        filename = "#{data_key.gsub('_','-')}.json"
        result = Cpbvt::Payloads::Aws::Runner.run data_key, params.merge({filename: filename})
        manifest.add_payload data_key, result
      end

      # load the local data
      data = manifest.get_output data_key.to_s

      # extract the data from the local file that we'll use to iterate
      iter_data = Cpbvt::Payloads::Aws::Extractor.send(
        "#{data_key}__#{extractor}",
        data
      )

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

        # the new payload key with the identifer
        payload_key = filename.sub(".json","")

        results.push [payload_key, result]
      end # iter_data.each 

    end # data_keys.each_with_index 

    results.each do |t|
      manifest.add_payload t[0], t[1]
    end
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
    #puts "[Output File] #{value}"

    return value
  end

  def self.execute command
    # print the command so we know what is running
    puts "[Executing] #{command}"
    # run the command which will download the json
    system command
  end
end