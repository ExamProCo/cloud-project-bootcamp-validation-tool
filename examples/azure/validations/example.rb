Cpbvt::Tester::Runner.describe :example do
  spec :should_have_account do |t|
    account_name = t.specific_params.storage_account_name
    account = assert_load("az-storage-account-list").find("name",account_name).returns(:all)
    assert_not_nil(account)
    set_pass_message "Found Azure Storage Account named #{account_name}"
    set_fail_message "Failed to Azure Storage Account named #{account_name}"
  end
  
  spec :should_have_container do |t|
    account_name = t.specific_params.storage_account_name
    container_name = t.specific_params.storage_container_name
    account = assert_load("az-storage-container-list__#{account_name}").find("name",container_name).returns(:all)

    assert_not_nil(account)
    set_pass_message "Found Azure Storage Account container named #{container_name}"
    set_fail_message "Failed to Azure Storage Account container named #{container_name}"
  end

  spec :should_have_blob do |t|
    account_name = t.specific_params.storage_account_name
    container_name = t.specific_params.storage_container_name
    blob_name = t.specific_params.storage_blob_name
    xblob_name = File.basename(blob_name, File.extname(blob_name))
    blob_result = assert_load("az-storage-blob-exists__#{account_name}__#{container_name}__#{xblob_name}").returns(:all)
    

    assert_eq(blob_result,'exists', true)

    set_pass_message "Found blob in container named #{blob_name}"
    set_fail_message "Failed blob in container named #{blob_name}"
  end
end