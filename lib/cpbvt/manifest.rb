require 'time'

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
    @ends_at = Time.now.to_i
    @user_uuid = user_uuid
    @run_uuid = run_uuid
    @project_scope = project_scope
    @output_path = output_path
    @payloads = {}
  end # init

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

  # write content to a file
  def write_file
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
end # class