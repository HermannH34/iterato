class LandingController < ApplicationController
  def index
  end

  def show_job
    @job = LandingContent::JOB_DETAILS[params[:slug]]
    render "landing/job_not_found" unless @job
  end
end
