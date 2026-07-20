class CandidateMailer < ApplicationMailer
  def community(candidate)
    @candidate = candidate
    mail subject: "Bienvenue dans la communauté Iterato", to: candidate.email
  end

  def job_application(candidate)
    @candidate = candidate
    mail subject: "Merci pour votre candidature", to: candidate.email
  end
end
