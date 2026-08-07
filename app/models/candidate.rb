class Candidate < ApplicationRecord
  SOURCES = %w[website linkedin email event referral manual].freeze

  scope :active, -> { where(deleted_at: nil) }

  validates :first_name, :last_name, :email, presence: true
  validates :profile_type, :experience_level, :linkedin_url, presence: true, unless: :manual?
  validates :entry_point, inclusion: { in: %w[community job_application] }
  validates :source, inclusion: { in: SOURCES }
  validate :email_uniqueness

  def manual?
    source == "manual"
  end

  private

  def email_uniqueness
    return if email.blank?

    scope = Candidate.active.where("LOWER(email) = ?", email.downcase)
    scope = scope.where.not(id: id) if persisted?
    scope = scope.where(source: "website") if source == "website"

    if scope.exists?
      errors.add(:email, :taken)
    end
  end
end
