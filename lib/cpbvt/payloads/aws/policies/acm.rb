module Cpbvt::Payloads::Aws::Policies::Acm
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/acm/describe-certificate.html
def acm_describe_certificate(aws_account_id:,region:)
  {
      "Effect" => "Allow",
      "Action" => "acm:DescribeCertificate",
      "Resource" =>  "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/acm/list-certificates.html
def acm_list_certificates(aws_account_id:,region:)
  {
    "Effect" =>  "Allow",
    "Action" => "acm:ListCertificates",
    "Resource" =>  "*"
  }
end
# ------
end; end