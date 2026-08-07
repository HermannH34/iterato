module Admin
  class CandidatesController < BaseController
    def index
      @candidates = Candidate.active.order(created_at: :desc)
    end

    def new
      @candidate = Candidate.new
    end

    def create
      @candidate = Candidate.new(candidate_params)
      @candidate.source = "manual"
      @candidate.entry_point = "community"
      handle_cv_upload(@candidate)

      if @candidate.save
        redirect_to admin_candidats_path, notice: "Candidat ajouté"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @candidate = Candidate.find(params[:id])
      redirect_to admin_candidats_path unless @candidate.manual?
    end

    def update
      @candidate = Candidate.find(params[:id])
      unless @candidate.manual?
        redirect_to admin_candidats_path
        return
      end

      handle_cv_upload(@candidate)

      if @candidate.update(candidate_params.except(:source, :entry_point))
        redirect_to admin_candidats_path, notice: "Candidat mis à jour"
      else
        render :edit, status: :unprocessable_entity
      end
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

    private

    def handle_cv_upload(candidate)
      file = params[:cv_file]
      return unless file.is_a?(ActionDispatch::Http::UploadedFile)

      candidate.cv_data = "data:application/pdf;base64,#{Base64.strict_encode64(file.read)}"
      candidate.cv_name = file.original_filename
    end

    def candidate_params
      params.require(:candidate).permit(
        :first_name, :last_name, :email,
        :profile_type, :experience_level, :linkedin_url
      )
    end
  end
end
