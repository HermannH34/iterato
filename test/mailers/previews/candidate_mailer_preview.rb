class CandidateMailerPreview < ActionMailer::Preview
  def community
    candidate = Candidate.new(
      first_name: "Hermann",
      last_name: "Hairet",
      email: "hermann@example.com",
      profile_type: "SRE",
      experience_level: "Senior",
      linkedin_url: "https://linkedin.com/in/hermannhairet",
      entry_point: "community"
    )
    CandidateMailer.community(candidate)
  end

  def job_application
    candidate = Candidate.new(
      first_name: "Hermann",
      last_name: "Hairet",
      email: "hermann@example.com",
      profile_type: "SRE",
      experience_level: "Senior",
      linkedin_url: "https://linkedin.com/in/hermannhairet",
      entry_point: "job_application"
    )
    CandidateMailer.job_application(candidate)
  end
end
