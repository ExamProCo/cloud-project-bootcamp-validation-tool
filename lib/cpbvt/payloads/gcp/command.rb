require 'open3'

class Cpbvt::Payloads::Gcp::Command
  include Cpbvt::Payloads::Gcp::Commands::Storage

  def self.login gcp_key_file
      command = <<~COMMAND
      gcloud auth activate-service-account \
      --key-file=#{gcp_key_file} \
      --format=json
      COMMAND
      puts "[Executing] #{command}"
      begin
        stdout_str, exit_code = Open3.capture2(command)#, :stdin_data=>post_content)
        result = JSON.parse(stdout_str)
      rescue => e
        puts "[ERROR] #{e.message}"
        result = e.message
      end
      return result
    end
end