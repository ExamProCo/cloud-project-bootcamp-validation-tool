module Cpbvt::Payloads::Gcp::Commands::Network
  def self.included base; base.extend ClassMethods; end
  module ClassMethods
  # ------


  def gcloud_compute_networks_list
  <<~COMMAND
    gcloud compute networks list
  COMMAND
  end

  # ------
  end; end
