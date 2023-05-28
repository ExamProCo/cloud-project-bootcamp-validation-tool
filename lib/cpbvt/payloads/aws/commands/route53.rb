module Cpbvt::Payloads::Aws::Commands::S3api
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def route53_list_hosted_zones(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws route53 list-hosted-zones \
--region #{region} --output json > #{output_file}
COMMAND
end

def route53_get_hosted_zone(region:, output_file: hosted_zone_id:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws route53 get-hosted-zone \
--id #{hosted_zone_id} \
--region #{region} --output json > #{output_file}
COMMAND
end

def route53_list_resource_record_sets(region:, output_file:,hosted_zone_id:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws route53 list-resource-record-sets \
--hosted-zone-id #{hosted_zone_id} \
--region #{region} --output json > #{output_file}
COMMAND

# ------
end; end