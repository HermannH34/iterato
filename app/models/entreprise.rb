class Entreprise < ApplicationRecord
  validates :first_name, :last_name, :email, :desired_profile, :context, :experience_level, presence: true
end
