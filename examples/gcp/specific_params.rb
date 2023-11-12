require 'active_model'
class Gcp::SpecificParams
  include ActiveModel::Validations

  attr_accessor :gcp_bucket_name

  validates :gcp_bucket_name, presence: true

  def initialize(
    gcp_bucket_name:)

    @gcp_bucket_name = gcp_bucket_name
  end
end