module Cpbvt::Payloads::Aws::Policies::Servicediscovery
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
def servicediscovery_list_services
end

def servicediscovery_list_namespaces
end
# ------
end; end