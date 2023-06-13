require 'time'
require 'json'
require 'zip'
require 'pry'

class Cpbvt::Manifest
  attr_accessor :payloads, # store all the payloads data structures
                :user_uuid,
                :run_uuid,
                :output_path,
                :project_scope,
                :starts_at,
                :ends_at

  def initialize(user_uuid:, run_uuid:, output_path:, project_scope:, payloads_bucket:)
    @starts_at = Time.now.to_f
    @user_uuid = user_uuid
    @run_uuid = run_uuid
    @project_scope = project_scope
    @output_path = output_path
    @payloads = {}
  end # init

  def archive!
    path = self.output_path
    zipfile_name = self.archive_path
    if Dir[File.join(path,'*')].any?
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        files = Dir.glob(File.join(path,'**','*'))
        basepath = File.join(@output_path, @project_scope, "user-#{@user_uuid}","/").to_s
        files.each do |file|
          zip_file_path = file.sub(basepath,"")
          puts zip_file_path
          zipfile.add(zip_file_path, file)
        end
      end
    end
  end # archive!

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
  
  def output_path
    File.join(
      @output_path, 
      @project_scope, 
      "user-#{@user_uuid}",
      "run-#{@run_uuid}"
    )
  end

  def archive_path
    File.join(
      @output_path, 
      @project_scope, 
      "user-#{@user_uuid}",
      "run-#{@run_uuid}.zip"
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
    key = _format_key(key)
    @payloads[key] = data
  end

  def has_payload? key
    key = _format_key(key)
    @payloads.has_key? key
  end

  def get_output key
    key = _format_key(key)
    return false unless @payloads.key?(key)
    output_file = @payloads[key][:output_file]
    json_data = File.read(output_file)
    puts "json_data: #{json_data}"
    hash = JSON.parse(json_data)
    return hash
  end

  # similar to get_output but has error handling
  def get_output! key
    key = _format_key(key)
    unless @payloads.key?(key)
      raise "#{key} not found in manifest"
      return
    end
    output_file = @payloads[key][:output_file]
    json_data = File.read(output_file)
    hash = JSON.parse(json_data)
    return hash
  end

  def _format_key key
    # if the key is symbol conver it to a string
    # if the key using hypens covert it to lowercase
    key.to_s.gsub(/-/,'_')
  end

  def payload_keys
    @payloads.keys
  end

  # write content to a file
  def write_file!
    @ends_at = Time.now.to_f
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
        duration_in_ms: ((@ends_at - @starts_at)*1000).to_i
      },
      payloads: @payloads
    }
  end
end # class