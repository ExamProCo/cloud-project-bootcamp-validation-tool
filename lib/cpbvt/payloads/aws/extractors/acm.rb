module Cpbvt::Payloads::Aws::Extractors::Acm
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# extract the certifcate arn from the AWS CLI command json output for acm_list_certificates
def acm_list_certificates__certificate_arn(data,filters={})
  if data['CertificateSummaryList']
    data['CertificateSummaryList'].map do |x| 
      arn     = x['CertificateArn'] 
      iter_id = arn.split("/").last
      { 
        iter_id: iter_id,
        certificate_arn:  arn
      }
    end
  end
end

# ------
end; end