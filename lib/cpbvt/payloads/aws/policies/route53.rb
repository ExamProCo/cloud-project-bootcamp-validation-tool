module Cpbvt::Payloads::Aws::Policies::Route53
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/route53/list-hosted-zones.html
def route53_list_hosted_zones(aws_account_id:)
  {
    "Effect" => "Allow",
    "Action" => [
        "route53:ListHostedZones",
        "route53:ListHostedZonesByName"
    ],
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/route53/get-hosted-zone.html
def route53_get_hosted_zone(aws_account_id:)
  {
    "Effect" => "Allow",
    "Action" => [
        "route53:GetHostedZone",
        "route53:ListHostedZones"
    ],
    "Resource" => ["*"]
  }
  # "arn:aws:route53:::hostedzone/<HostedZoneId>",
  # "arn:aws:route53:::hostedzone"
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/route53/list-resource-record-sets.html
def route53_list_resource_record_sets(aws_account_id:)
  {
    "Effect" => "Allow",
    "Action" => [
        "route53:ListResourceRecordSets",
        "route53:ListHostedZones"
    ],
    "Resource" => "*"
  }
end

# ------
end; end