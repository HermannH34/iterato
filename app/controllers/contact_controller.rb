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
      render json: { success: true }, status: :created
    else
      render json: { error: "Champs requis manquants" }, status: :unprocessable_entity
    end
  end

  private

  def candidate_params
    p = params.permit(:firstName, :lastName, :email, :profileType, :experienceLevel, :linkedinUrl, :cvData, :cvName)
              .transform_keys! { |k| k.to_s.underscore }
    p
  end

  def entreprise_params
    p = params.permit(:firstName, :lastName, :email, :profileType, :context, :experienceLevel)
              .transform_keys! { |k| k.to_s.underscore }
    p[:desired_profile] = p.delete(:profile_type) || p.delete("profile_type")
    p
  end
end
