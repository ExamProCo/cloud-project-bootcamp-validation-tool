require 'cloud_project_bootcamp_validation_tool'
require 'dotenv'

namespace :run do
  task :aws_2023 do
    puts "aws_2023 =="
    Cpbvt::Aws2023.run(
      project_scope: "aws-bootcamp-2023",
      user_uuid: ENV['USER_UUID'],
      region: ENV['USER_AWS_REGION'],
      output_path: ENV['OUTPUT_PATH']
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      payloads_bucket: ENV['PAYLOADS_BUCKET']
    )
  end
end