class ContactRequest < ApplicationRecord
  validates :first_name, :email, :form_type, presence: true
end
