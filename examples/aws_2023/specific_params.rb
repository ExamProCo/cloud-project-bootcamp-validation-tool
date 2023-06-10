require 'active_model'
class Aws2023::GeneralParams
  include ActiveModel::Validations

  attr_accessor :naked_domain_name

  validates :domain_name, presence: true, format: { with: /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix }

  def initialize(naked_domain_name:)
    @naked_domain_name = naked_domain_name
  end
end