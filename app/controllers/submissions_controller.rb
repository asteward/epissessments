class SubmissionsController < ApplicationController
  def index
    @submissions = Submission.all
    authorize! :read, @submissions
  end

  def new
    @assessment = Assessment.find(params[:assessment_id])
    @submission = @assessment.submissions.new
    authorize! :create, @submission
  end

  def create
    @assessment = Assessment.find(params[:assessment_id])
    @submission = @assessment.submissions.new(submission_params)
    @submission.user_id = current_user.id
    if @submission.save
      @submission.assessment_id = @assessment.id
      redirect_to assessments_path, notice: "Thanks for your submission!"
    else
      render 'new'
    end
    authorize! :create, @submission
  end

  def show
    @submission = Submission.find(params[:id])
    authorize! :read, @submission
  end

  def edit
    @submission = Submission.find(params[:id])
    authorize! :update, @submission
  end

  def update
    @submission = Submission.find(params[:id])
    if @submission.update(submission_params)
      redirect_to assessment_submission_url, notice: "Submission updated!"
    else
      render 'new'
    end
    authorize! :update, @submission
  end

  def destroy
    authorize! :destroy, @submission
  end

private

  def submission_params
    params.require(:submission).permit(:link, :note)
  end

end
