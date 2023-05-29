module Cpbvt::Payloads::Aws::CommandsModules::Acm
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/acm/describe-certificate.html
def acm_describe_certificate(certificate_arn:)
<<~COMMAND
aws acm describe-certificate  \
--certificate-arn #{certificate_arn}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/acm/list-certificates.html
def acm_list_certificates
<<~COMMAND
aws acm list-certificates
COMMAND
end
# ------
end; end