require 'time'
require 'json'
require 'zlib'

class Cpbvt::Manifest
  attr_accessor :payloads, # store all the payloads data structures
                :user_uuid,
                :run_uuid,
                :output_path,
                :project_scope,
                :starts_at,
                :ends_at

  def initialize(user_uuid:, run_uuid:, output_path:, project_scope:, payloads_bucket:)
    @starts_at = Time.now.to_i
    @user_uuid = user_uuid
    @run_uuid = run_uuid
    @project_scope = project_scope
    @output_path = output_path
    @payloads = {}
  end # init

  # Pull S3 if the local files don't exist
  def pull!
  end

  # Load a manifest file
  def load_from_file!
    path = self.output_file
    if File.exist?(path)
      json = File.read(path)
      data = JSON.parse(json)
      @user_uuid = data['metadata']['user_uuid']
      @run_uuid = data['metadata']['run_uuid']
      @project_scope = data['metadata']['project_scope']
      @payloads = {}
      data['payloads'].each do |key,payload|
        @payloads[key] = {
          object_key: payload['object_key'],
          output_file: payload['output_file'],
          command: payload['command']
        }
      end
    else
      raise "Manifest.load_from_file! Couldn't find Manifest file at: #{path}"
    end
  end

  def output_file
    File.join(
      @output_path, 
      @project_scope, 
      "user-#{@user_uuid}",
      "run-#{@run_uuid}",
      "manifest.json"
    )
  end

  def object_key
    File.join(
      @project_scope, 
      "user-#{@user_uuid}",
      "run-#{@run_uuid}",
      "manifest.json"
    )
  end

  def add_payload key, data
    @payloads[key] = data
  end

  def has_payload? key
    @payloads.has_key? key
  end

  def get_output key
    output_file = @payloads[key][:output_file]
    json_data = File.read(output_file)
    hash = JSON.parse(json_data)
    return hash
  end

  # write content to a file
  def write_file
    @ends_at = Time.now.to_i
    File.open(self.output_file, 'w') do |f|
      f.write(JSON.pretty_generate(self.contents))
    end
  end

  def contents
    {
      metadata: {
        user_uuid: @user_uuid,
        run_uuid: @run_uuid,
        project_scope: @project_scope,
      },
      benchmark: {
        starts_at: @starts_at,
        ends_at: @ends_at,
        duration_in_seconds: @ends_at - @starts_at
      },
      payloads: @payloads
    }
  end

  def 
end # class