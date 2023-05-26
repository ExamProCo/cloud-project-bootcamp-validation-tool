class Cpbvt::Payloads::Aws::Policies
  # return the statement for the permission required to do ec2 describe vpc
  def self.ec2_describe_vpcs(region:)
    {
      "Sid" => "AllowEC2DescribeVPCs",
      "Effect" => "Allow",
      "Action" => "ec2:DescribeVpcs",
      "Resource" => "*",
      "Condition" => {
        "StringEquals" => {
          "ec2:Region" => region
        }
      }
    }
  end

  def self.s3api_list_buckets
    {
      "Sid" => "AllowS3ListBuckets",
      "Effect" => "Allow",
      "Action" => "s3:ListAllMyBuckets",
      "Resource" => "*"
    }
  end

  def self.ec2_describe_subnets(region:)
    {
      "Sid" => "AllowEC2DescribeSubnets",
      "Effect" => "Allow",
      "Action" => "ec2:DescribeSubnets",
      "Resource" => "*",
      "Condition" => {
        "StringEquals" => {
          "ec2:Region" => region
          }
      }
    }
  end
end