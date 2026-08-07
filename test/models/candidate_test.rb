require "test_helper"

class CandidateTest < ActiveSupport::TestCase
  test "valid candidate from website requires all fields" do
    candidate = Candidate.new(
      first_name: "Test",
      last_name: "User",
      email: "test@example.com",
      profile_type: "DevOps Engineer",
      experience_level: "Senior",
      linkedin_url: "https://linkedin.com/in/test",
      entry_point: "community",
      source: "website"
    )
    assert candidate.valid?
  end

  test "website candidate requires profile_type" do
    candidate = Candidate.new(
      first_name: "Test",
      last_name: "User",
      email: "test@example.com",
      experience_level: "Senior",
      linkedin_url: "https://linkedin.com/in/test",
      entry_point: "community",
      source: "website"
    )
    assert_not candidate.valid?
    assert_includes candidate.errors[:profile_type], "can't be blank"
  end

  test "manual candidate only requires first_name, last_name, and email" do
    candidate = Candidate.new(
      first_name: "Test",
      last_name: "User",
      email: "manual@example.com",
      source: "manual",
      entry_point: "community"
    )
    assert candidate.valid?
  end

  test "manual candidate still requires first_name" do
    candidate = Candidate.new(
      last_name: "User",
      email: "manual@example.com",
      source: "manual",
      entry_point: "community"
    )
    assert_not candidate.valid?
    assert_includes candidate.errors[:first_name], "can't be blank"
  end

  test "manual candidate still requires email" do
    candidate = Candidate.new(
      first_name: "Test",
      last_name: "User",
      source: "manual",
      entry_point: "community"
    )
    assert_not candidate.valid?
    assert_includes candidate.errors[:email], "can't be blank"
  end

  test "email must be unique" do
    Candidate.create!(
      first_name: "First",
      last_name: "User",
      email: "duplicate@example.com",
      profile_type: "DevOps Engineer",
      experience_level: "Senior",
      linkedin_url: "https://linkedin.com/in/first",
      entry_point: "community",
      source: "website"
    )

    duplicate = Candidate.new(
      first_name: "Second",
      last_name: "User",
      email: "duplicate@example.com",
      source: "manual",
      entry_point: "community"
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "email uniqueness is case insensitive" do
    Candidate.create!(
      first_name: "First",
      last_name: "User",
      email: "CaseSensitive@Example.com",
      profile_type: "SRE",
      experience_level: "Junior",
      linkedin_url: "https://linkedin.com/in/case",
      entry_point: "community",
      source: "website"
    )

    duplicate = Candidate.new(
      first_name: "Second",
      last_name: "User",
      email: "casesensitive@example.com",
      source: "manual",
      entry_point: "community"
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "email uniqueness ignores soft-deleted candidates" do
    Candidate.create!(
      first_name: "Deleted",
      last_name: "User",
      email: "deleted@example.com",
      source: "manual",
      entry_point: "community",
      deleted_at: Time.current
    )

    new_candidate = Candidate.new(
      first_name: "New",
      last_name: "User",
      email: "deleted@example.com",
      source: "manual",
      entry_point: "community"
    )
    assert new_candidate.valid?
  end

  test "website candidate allowed when manual candidate has same email" do
    Candidate.create!(
      first_name: "Manual",
      last_name: "User",
      email: "shared@example.com",
      source: "manual",
      entry_point: "community"
    )

    website_candidate = Candidate.new(
      first_name: "Website",
      last_name: "User",
      email: "shared@example.com",
      profile_type: "SRE",
      experience_level: "Senior",
      linkedin_url: "https://linkedin.com/in/web",
      entry_point: "community",
      source: "website"
    )
    assert website_candidate.valid?
  end

  test "manual candidate blocked when website candidate has same email" do
    Candidate.create!(
      first_name: "Website",
      last_name: "User",
      email: "shared@example.com",
      profile_type: "SRE",
      experience_level: "Senior",
      linkedin_url: "https://linkedin.com/in/web",
      entry_point: "community",
      source: "website"
    )

    manual_candidate = Candidate.new(
      first_name: "Manual",
      last_name: "User",
      email: "shared@example.com",
      source: "manual",
      entry_point: "community"
    )
    assert_not manual_candidate.valid?
    assert_includes manual_candidate.errors[:email], "has already been taken"
  end

  test "source must be a valid value" do
    candidate = Candidate.new(
      first_name: "Test",
      last_name: "User",
      email: "test@example.com",
      source: "invalid_source",
      entry_point: "community"
    )
    assert_not candidate.valid?
    assert_includes candidate.errors[:source], "is not included in the list"
  end

  test "manual? returns true for manual source" do
    candidate = Candidate.new(source: "manual")
    assert candidate.manual?
  end

  test "manual? returns false for website source" do
    candidate = Candidate.new(source: "website")
    assert_not candidate.manual?
  end

  test "active scope excludes soft-deleted candidates" do
    active = Candidate.create!(
      first_name: "Active",
      last_name: "User",
      email: "active@example.com",
      source: "manual",
      entry_point: "community"
    )

    deleted = Candidate.create!(
      first_name: "Deleted",
      last_name: "User",
      email: "deleted@example.com",
      source: "manual",
      entry_point: "community",
      deleted_at: Time.current
    )

    active_ids = Candidate.active.pluck(:id)
    assert_includes active_ids, active.id
    assert_not_includes active_ids, deleted.id
  end
end
