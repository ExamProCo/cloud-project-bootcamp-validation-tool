require 'open3'

class Cpbvt::Payloads::Azure::Command
  include Cpbvt::Payloads::Azure::Commands::Storage

  def self.login azure_client_id, azure_secret_client, azure_tenant_id
command = <<~COMMAND
az login --service-principal \
         --username #{azure_client_id} \
         --password #{azure_secret_client} \
         --tenant #{azure_tenant_id}
COMMAND
puts "[Executing] #{command}"

      begin
        stdout_str, exit_code = Open3.capture2(command)#, :stdin_data=>post_content)
        payload = JSON.parse(stdout_str)
        result = payload['Credentials']
        # TODO - check the result
      rescue => e
        puts "[ERROR] #{e.message}"
        result = e.message
      end
      return result
    end
end