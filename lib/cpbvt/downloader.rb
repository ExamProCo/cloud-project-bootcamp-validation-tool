require 'aws-sdk-s3'

class Cpbvt::Downloader
  def self.run(file_path:,
               object_key:,
               aws_region:,
               aws_access_key_id:,
               aws_secret_access_key:,
               payloads_bucket:)
    #Aws.config.update({
    #  credentials: Aws::Credentials.new(
    #    aws_access_key_id,
    #    aws_secret_access_key
    #  )
    #})
    ## Create an S3 client
    #s3_client = Aws::S3::Client.new

    #File.open(file_path, 'wb') do |file|
    #  s3.get_object({ bucket: payloads_bucket, key: object_key }, target: file)
    #end
  end
end
