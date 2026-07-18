module Admin
  class CandidatesController < BaseController
    def index
      @candidates = Candidate.order(created_at: :desc)
    end

    def download_cv
      candidate = Candidate.find(params[:id])

      if candidate.cv_data.present?
        pdf = Base64.decode64(candidate.cv_data)
        send_data pdf, filename: candidate.cv_name.presence || "CV.pdf", type: "application/pdf"
      else
        head :not_found
      end
    end
  end
end
