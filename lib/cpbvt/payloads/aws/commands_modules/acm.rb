module Cpbvt::Payloads::Aws::CommandsModules::Acm
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def acm_describe_certificate(region:, output_file:, certificate_arn:)
command = <<~COMMAND.strip.gsub("\n", " ")
  aws acm describe-certificate  \
  --certificate-arn #{certificate_arn} \
  --region #{region} --output json > #{output_file}
COMMAND
end


def acm_list_certificates(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
    aws acm list-certificates \
    --region #{region} --output json > #{output_file}
COMMAND
end
# ------
end; end