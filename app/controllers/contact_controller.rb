class ContactController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token

  def create
    case params[:formType]
    when "candidate"
      contact = Candidate.new(candidate_params)
    when "entreprise"
      contact = Entreprise.new(entreprise_params)
    else
      render json: { error: "Type de formulaire inconnu" }, status: :unprocessable_entity
      return
    end

    if contact.save
      if contact.is_a?(Candidate)
        send_candidate_email(contact)
      end
      render json: { success: true }, status: :created
    else
      render json: { error: "Champs requis manquants" }, status: :unprocessable_entity
    end
  end

  private

  def send_candidate_email(candidate)
    mailer = case candidate.entry_point
    when "job_application" then CandidateMailer.job_application(candidate)
    else CandidateMailer.community(candidate)
    end

    mailer.deliver_later
    candidate.update_column(:confirmation_email_sent_at, Time.current)
  rescue => e
    Rails.logger.error("Failed to send candidate email ##{candidate.id}: #{e.message}")
  end

  def candidate_params
    params.permit(:firstName, :lastName, :email, :profileType, :experienceLevel, :linkedinUrl, :cvData, :cvName, :entryPoint)
          .transform_keys { |k| k.to_s.underscore }
  end

  def entreprise_params
    p = params.permit(:firstName, :lastName, :email, :profileType, :context, :experienceLevel)
              .transform_keys! { |k| k.to_s.underscore }
    p[:desired_profile] = p.delete(:profile_type) || p.delete("profile_type")
    p
  end
end