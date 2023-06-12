module Cpbvt::Payloads::Aws::Extractors::Codebuild
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
  
  # extract the certifcate arn from the AWS CLI command json output for acm_list_certificates
  def codebuild_list_projects__project_name(data,filters={})
    data['projects'].map do |project_name| 
      { 
        iter_id: project_name,
        project_name: project_name
      }
    end
  end
  
# ------
end; end