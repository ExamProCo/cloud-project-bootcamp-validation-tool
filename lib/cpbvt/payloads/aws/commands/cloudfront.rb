module Cpbvt::Payloads::Aws::Commands::Cloudfront
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cloudfront_list_distributions(region: output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cloudfront list-distributions \
--output json > #{output_file}
COMMAND
end

def cloudfront_get_distribution(output_file:, distribution_id:)
  command = <<~COMMAND.strip.gsub("\n", " ")
  aws cloudfront get-distribution \
  --id #{distribution_id} \
  --output json > #{output_file}
COMMAND
end
  
# ------
end; end