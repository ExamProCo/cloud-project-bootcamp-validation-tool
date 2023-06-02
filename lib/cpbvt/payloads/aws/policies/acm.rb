module Cpbvt::Payloads::Aws::Policies::Acm
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/acm/describe-certificate.html
def acm_describe_certificate(certificate_arn:)
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/acm/list-certificates.html
def acm_list_certificates
end
# ------
end; end