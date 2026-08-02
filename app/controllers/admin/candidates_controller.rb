module Admin
  class CandidatesController < BaseController
    def index
      @candidates = Candidate.active.order(created_at: :desc)
    end

    def destroy
      candidate = Candidate.find(params[:id])
      candidate.update(deleted_at: Time.current)
      redirect_to admin_candidats_path, notice: "Candidat supprimé"
    end

    def download_cv
      candidate = Candidate.find(params[:id])

      if candidate.cv_data.present?
        raw = candidate.cv_data.sub(/\Adata:application\/pdf;base64,/, "")
        pdf = Base64.decode64(raw)
        send_data pdf, filename: candidate.cv_name.presence || "CV.pdf", type: "application/pdf"
      else
        head :not_found
      end
    end
  end
end
