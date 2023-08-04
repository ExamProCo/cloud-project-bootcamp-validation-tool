module Cpbvt::Payloads::Aws::Policies::Acm
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def acm_allow_general_permissions(aws_account_id:)
  {
    "Effect" => "Allow",
    "Action" => [
      "acm:ListCertificates",
      "acm:DescribeCertificate"
    ],
    "Resource" => "*"
  }
end

# ------
end; end