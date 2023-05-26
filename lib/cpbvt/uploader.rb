require 'aws-sdk-s3'

# This class is response for uploading json files to S3
# The files contain about from API calls from CLI tools
# We are storing them to hold on for auditing.
class Cpbvt::Uploader
  # file_path - the path to the json file to be uploaded
  # object_key - the s3 object key that the file will use in the bucket
  def self.run(file_path:, 
               object_key:,
               aws_region:,
               aws_access_key_id:,
               aws_secret_access_key:,
               payloads_bucket:)
    Aws.config.update({
      region: aws_region,
      credentials: Aws::Credentials.new(
        aws_access_key_id,
        aws_secret_access_key
      )
    })

    # Create an S3 client
    s3_client = Aws::S3::Client.new

    # Read the JSON file content
    file_content = File.read(file_path)

    begin
      # Upload the JSON file to S3
      s3_client.put_object({
        bucket: payloads_bucket,
        key: object_key,
        body: file_content
      })
      puts 'File uploaded successfully.'
    rescue Aws::S3::Errors::ServiceError => e
      puts "AWS S3 service error: #{e.message}"
    rescue Errno::ENOENT => e
      puts "File not found error: #{e.message}"
    rescue StandardError => e
      puts "Error uploading file: #{e.message}"
    end
  end # self.run

  # create the key to where the json file will be uploaded into the bucket
  def self.object_key user_uuid:,
                      project_scope:,
                      run_uuid:,
                      region:, 
                      filename:
    value = File.join(
      project_scope, 
      "user-#{user_uuid}",
      "run-#{run_uuid}",
      region, 
      filename
    )

    # print the desination of the outputed json
    puts "[Output Key] #{value}"

    return value
  end
end # class