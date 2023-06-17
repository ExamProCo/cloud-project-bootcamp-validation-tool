module Cpbvt::Payloads::Aws::Policies::Servicediscovery
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
def servicediscovery_list_services(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "servicediscovery:ListServices",
    "Resource" => "*"
}
end

def servicediscovery_list_namespaces(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "servicediscovery:ListNamespaces",
    "Resource" => "*"
}
end
# ------
end; end