require 'active_model'
class Azure::SpecificParams
  include ActiveModel::Validations

  attr_accessor :storage_account_name,
                :storage_container_name,
                :storage_blob_name

  validates :storage_account_name, presence: true
  validates :storage_container_name, presence: true
  validates :storage_blob_name, presence: true

  def initialize(
    storage_account_name:,
    storage_container_name:,
    storage_blob_name:)

    @storage_account_name   = storage_account_name
    @storage_container_name = storage_container_name
    @storage_blob_name      = storage_blob_name
  end
end