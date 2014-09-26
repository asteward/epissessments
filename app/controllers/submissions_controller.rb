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
    binding.pry
    @assessments = Assessment.all
    @assessment = Assessment.find(params[:assessment_id])
    @submission = @assessment.submissions.new(submission_params)
    @submission.user_id = current_user.id
      if @submission.save
        @assessment.requirements.each do |req|
          Grade.find_or_create_by(score: 3, submission_id: @submission.id, requirement_id: req.id)
      end
      redirect_to assessment_submission_url(@assessment, @submission), notice: "Submission added!"
    else
      flash[:alert] = "Sorry, try again!"
      render 'assessments/index'
    end
    authorize! :create, @submission
  end

  def show
    @submission = Submission.find(params[:id])
    @assessment = Assessment.find(params[:assessment_id])
    # if @submission.grades.count < @assessment.requirements.count
    #   @assessment.requirements.each do |requirement|
    #     @submission.grades.new(requirement: requirement)
    #   end
    # end
    authorize! :read, @submission
  end

  def edit
    @submission = Submission.find(params[:id])
    authorize! :update, @submission
  end

  def update
    @submission = Submission.find(params[:id])
    @assessment = Assessment.find(params[:assessment_id])
    if @submission.update(submission_params)
      redirect_to assessment_submission_url, notice: "Submission updated!"
    else
      render 'show'
    end
    authorize! :update, @submission
  end

  def destroy
    authorize! :destroy, @submission
  end

private

  def submission_params
    params.require(:submission).permit(:link, :note, :grades_attributes => [:score, :submission_id, :requirement_id]).merge(user_id: current_user.id)
  end

end
