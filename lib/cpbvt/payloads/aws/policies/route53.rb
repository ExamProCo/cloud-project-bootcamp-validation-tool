module Cpbvt::Payloads::Aws::Policies::Route53
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def route53_allow_general_permissions(aws_account_id:)
  {
    "Effect" => "Allow",
    "Action" => [
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets"
    ],
    "Resource" => "*"
  }
end

# ------
end; end