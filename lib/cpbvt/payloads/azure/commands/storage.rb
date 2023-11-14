module Cpbvt::Payloads::Azure::Commands::Storage
  def self.included base; base.extend ClassMethods; end
  module ClassMethods
  # ------
  
  # https://learn.microsoft.com/en-us/cli/azure/storage/account?view=azure-cli-latest#az-storage-account-list
  def az_storage_account_list
<<~COMMAND
az storage account list
COMMAND
  end
  
  # https://learn.microsoft.com/en-us/cli/azure/storage/container?view=azure-cli-latest#az-storage-container-list
  def az_storage_container_list account_name:
<<~COMMAND
az storage container list \
--auth-mode login \
--account-name #{account_name}
COMMAND
  end

  # https://learn.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-exists
  def az_storage_blob_exists account_name:, container_name:, blob_name:
<<~COMMAND
az storage blob exists  \
--account-name #{account_name} \
--container-name #{container_name} \
--auth-mode login \
--name #{blob_name}
COMMAND
  end


  # ------
  end; end