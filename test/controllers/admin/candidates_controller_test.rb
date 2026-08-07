require "test_helper"

class Admin::CandidatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    post session_url, params: { email_address: @user.email_address, password: "password123" }
  end

  test "new renders form" do
    get new_admin_candidate_url
    assert_response :success
  end

  test "create with valid params creates manual candidate" do
    assert_difference("Candidate.count", 1) do
      post admin_candidates_url, params: {
        candidate: {
          first_name: "Jean",
          last_name: "Nouveau",
          email: "jean.nouveau@example.com"
        }
      }
    end

    candidate = Candidate.last
    assert_equal "manual", candidate.source
    assert_equal "community", candidate.entry_point
    assert_nil candidate.confirmation_email_sent_at
    assert_redirected_to admin_candidats_url
  end

  test "create with all optional params" do
    post admin_candidates_url, params: {
      candidate: {
        first_name: "Jean",
        last_name: "Complet",
        email: "jean.complet@example.com",
        profile_type: "SRE",
        experience_level: "Senior",
        linkedin_url: "https://linkedin.com/in/jean"
      }
    }

    candidate = Candidate.last
    assert_equal "SRE", candidate.profile_type
    assert_equal "Senior", candidate.experience_level
    assert_equal "https://linkedin.com/in/jean", candidate.linkedin_url
  end

  test "create with duplicate email shows error" do
    Candidate.create!(
      first_name: "Existing",
      last_name: "User",
      email: "taken@example.com",
      source: "manual",
      entry_point: "community"
    )

    assert_no_difference("Candidate.count") do
      post admin_candidates_url, params: {
        candidate: {
          first_name: "New",
          last_name: "User",
          email: "taken@example.com"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "create with missing required fields shows error" do
    assert_no_difference("Candidate.count") do
      post admin_candidates_url, params: {
        candidate: {
          first_name: "Only",
          last_name: "",
          email: "missing@example.com"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "edit renders form for manual candidate" do
    candidate = candidates(:manual_candidate)
    get edit_admin_candidate_url(candidate)
    assert_response :success
  end

  test "edit redirects for website candidate" do
    candidate = candidates(:website_community)
    get edit_admin_candidate_url(candidate)
    assert_redirected_to admin_candidats_url
  end

  test "update changes manual candidate" do
    candidate = candidates(:manual_candidate)
    patch admin_candidate_url(candidate), params: {
      candidate: {
        profile_type: "DevOps Engineer",
        experience_level: "Lead"
      }
    }

    candidate.reload
    assert_equal "DevOps Engineer", candidate.profile_type
    assert_equal "Lead", candidate.experience_level
    assert_redirected_to admin_candidats_url
  end

  test "update rejects website candidate" do
    candidate = candidates(:website_community)
    patch admin_candidate_url(candidate), params: {
      candidate: { profile_type: "Hacker" }
    }

    candidate.reload
    assert_equal "DevOps Engineer", candidate.profile_type
    assert_redirected_to admin_candidats_url
  end

  test "update does not change source or entry_point" do
    candidate = candidates(:manual_candidate)
    patch admin_candidate_url(candidate), params: {
      candidate: {
        source: "linkedin",
        entry_point: "job_application",
        profile_type: "SRE"
      }
    }

    candidate.reload
    assert_equal "manual", candidate.source
    assert_equal "community", candidate.entry_point
  end

  test "create does not send confirmation email" do
    assert_no_enqueued_emails do
      post admin_candidates_url, params: {
        candidate: {
          first_name: "No",
          last_name: "Email",
          email: "noemail@example.com"
        }
      }
    end
  end
end
