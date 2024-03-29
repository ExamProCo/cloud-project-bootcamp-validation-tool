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
               payloads_bucket:,
               public_read: false)
    Aws.config.update({
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
      attrs = {
        bucket: payloads_bucket,
        key: object_key,
        body: file_content
      }
      # when working with azure arm templates we need to make them public in S3
      # the payload bucket also requires a CORS policy to allow portal.azure.com to GET
      # nothing sensitive is contained inside the ligthhouse template and it is removed after validation is complete
      if public_read == true
        attrs[:acl] = 'public-read'
      end
      s3_client.put_object attrs
      puts 'File uploaded successfully.'
    rescue Aws::S3::Errors::ServiceError => e
      puts "AWS S3 service error: #{e.message}"
    rescue Errno::ENOENT => e
      puts "File not found error: #{e.message}"
    rescue StandardError => e
      puts "Error uploading file: #{e.message}"
    end
  end # self.run

  # return a presigned url for uploaded files - required when a user must download templates
  def self.presigned_url key:,
                    payloads_bucket:
    Aws::S3::Presigner.new.presigned_url(:get_object, bucket: payloads_bucket, key: key)
  end

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
    #puts "[Output Key] #{value}"

    return value
  end
end # class
