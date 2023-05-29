module Cpbvt::Payloads::Aws::Extractors::Acm
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# extract the certifcate arn from the AWS CLI command json output for acm_list_certificates
def acm_list_certificates_from_extract_certificate_arns(data)
  data['CertificateSummaryList'].map do |x| 
    arn     = x['CertificateArn'] 
    iter_id = arn.split("/").last
    { 
      iter_id: iter_id,
      certificate_arn:  arn
    }
  end
end

# ------
end; end