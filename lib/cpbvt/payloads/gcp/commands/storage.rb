module Cpbvt::Payloads::Gcp::Commands::Storage
  def self.included base; base.extend ClassMethods; end
  module ClassMethods
  # ------
  
  # https://cloud.google.com/sdk/gcloud/reference/storage/buckets/list
  def gcloud_storage_buckets_list
  <<~COMMAND
gcloud storage buckets list
  COMMAND
  end
  
  # https://cloud.google.com/sdk/gcloud/reference/storage/objects/describe
  def gcloud_storage_objects_describe bucket_name:, object_name:
  <<~COMMAND
 gcloud storage objects describe \
 gs://#{bucket_name}/#{object_name}
  COMMAND
  end
  # ------
  end; end