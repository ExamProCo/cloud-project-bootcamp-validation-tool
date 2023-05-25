require 'aws-sdk-ec2'

# This function uses the AWS CLI to download a list of vpcs as json
def get_vpcs(region)
  system "aws ec2 describe-vpcs --region #{region} > vpcs.json"
end