class ContactController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    contact = ContactRequest.new(contact_params)
    if contact.save
      render json: { success: true }, status: :created
    else
      render json: { error: "Champs requis manquants" }, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.permit(:firstName, :lastName, :email, :profileType, :context, :experienceLevel, :linkedinUrl, :cvData, :cvName, :formType).transform_keys! do |key|
      key.to_s.underscore
    end
  end
end
