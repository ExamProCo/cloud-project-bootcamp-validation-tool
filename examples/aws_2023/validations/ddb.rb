class Aws2023::Validations::Ddb
  def self.should_have_ddb_table(manifest:,specific_params:)
    resource = Cpbvt::Payloads::Aws::Extractor.cloudformation_list_stacks__by_stack_resource_type(
      manifest,
      'CrdDdb',
      "AWS::DynamoDB::Table"
    )
    table_name = resource['PhysicalResourceId']
    data = manifest.get_output!("dynamodb-describe-table__#{table_name}")['Table']

    pk =
    data['KeySchema'].find do |t|
      t['AttributeName'] == 'pk' && t['KeyType'] == 'HASH'
    end

    sk =
    data['KeySchema'].find do |t|
      t['AttributeName'] == 'sk' && t['KeyType'] == 'RANGE'
    end

    found =
    pk &&
    sk &&
    data['TableStatus'] == 'ACTIVE' &&
    data['TableSizeBytes'] > 0 &&
    data['ItemCount'] > 0

    if found
      {result: {score: 10, message: "Found dynamodb table with data in it "}}
    else
      {result: {score: 0, message: "Failed to find dynamodb table with data in it"}}
    end
  end

  def self.should_have_gsi(manifest:,specific_params:)
    resource = Cpbvt::Payloads::Aws::Extractor.cloudformation_list_stacks__by_stack_resource_type(
      manifest,
      'CrdDdb',
      "AWS::DynamoDB::Table"
    )
    table_name = resource['PhysicalResourceId']
    data = manifest.get_output!("dynamodb-describe-table__#{table_name}")['Table']

    gsi = data['GlobalSecondaryIndexes'].first

    pk =
    gsi['KeySchema'].find do |t|
      t['AttributeName'] == 'message_group_uuid' && t['KeyType'] == 'HASH'
    end

    sk =
    gsi['KeySchema'].find do |t|
      t['AttributeName'] == 'sk' && t['KeyType'] == 'RANGE'
    end

    found =
    pk &&
    sk &&
    gsi['IndexStatus'] == 'ACTIVE' &&
    gsi['IndexSizeBytes'] > 0 &&
    gsi['ItemCount'] > 0

    if found
      {result: {score: 10, message: "Found dynamodb table GSI with data in it "}}
    else
      {result: {score: 0, message: "Failed to find dynamodb table GSI with data in it"}}
    end
  end

  def self.should_have_ddb_stream(manifest:,specific_params:)
    resource = Cpbvt::Payloads::Aws::Extractor.cloudformation_list_stacks__by_stack_resource_type(
      manifest,
      'CrdDdb',
      "AWS::DynamoDB::Table"
    )
    table_name = resource['PhysicalResourceId']
    data = manifest.get_output!("dynamodb-describe-table__#{table_name}")['Table']

    label = data['LatestStreamLabel']

    stream_data = manifest.get_output!("dynamodbstreams-describe-stream__#{label}")

    found =
    stream_data['StreamDescription']['StreamStatus'] == 'ENABLED' &&
    stream_data['StreamDescription']['StreamViewType'] == 'NEW_IMAGE'

    if found
      {result: {score: 10, message: "Found dynamodb stream with NEW_IMAGE"}}
    else
      {result: {score: 0, message: "Failed to find dynamodb stream with NEW_IMAGE"}}
    end
  end
end