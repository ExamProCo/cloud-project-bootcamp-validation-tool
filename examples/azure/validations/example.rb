Cpbvt::Tester::Runner.describe :example do
  spec :should_have_account do |t|

  end
  
  spec :should_have_container do |t|
    account_name = t.specific_params.storage_account_name
  end

  spec :should_have_blob do |t|
    account_name = t.specific_params.storage_account_name
    container_name = t.specific_params.storage_container_name
    blob_name = t.specific_params.blob_name
  end
end