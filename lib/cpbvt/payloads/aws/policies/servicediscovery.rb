module Cpbvt::Payloads::Aws::Policies::Servicediscovery
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def servicediscovery_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "servicediscovery:ListServices",
      "servicediscovery:ListNamespaces"
    ],
    "Resource" => "*"
  }
end
# ------
end; end