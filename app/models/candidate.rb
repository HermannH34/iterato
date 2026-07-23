class Candidate < ApplicationRecord
  validates :first_name, :last_name, :email, :profile_type, :experience_level, :linkedin_url, presence: true
  validates :entry_point, inclusion: { in: %w[community job_application] }
end
