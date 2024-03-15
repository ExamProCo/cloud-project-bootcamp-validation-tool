module Cpbvt::Payloads::Terraform::Commands::State
  def self.included base; base.extend ClassMethods; end
  module ClassMethods
  # ------
  
  def terraform_state_pull(terraform_token:, policy_path:)
  <<~COMMAND
    export TF_TOKEN_app_terraform_io=#{terraform_token} && \
    cd #{policy_path} && \
    terraform init && \
    terraform state pull
  COMMAND
  end

  # ------
  end; end