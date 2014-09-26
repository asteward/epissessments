class GradesController < ApplicationController
  def new
    @grade = Grade.new
  end

  def create
    @grade = Grade.new(grade_params)
    @submission = Submission.find(params[:grade][:submission_id])
    @requirements = @submission.requirements
    @assessment = Assessment.find(@submission.assessment_id)
      # if @grade.save
      #   respond_to do |format|
      #     format.html { redirect_to assessment_submission_path(@assessment, @submission) }
      #     format.js
      #   end
      # end
  end

private
  def grade_params
    params.require(:grade).permit(:comment, :score, :requirement_id, :submission_id).merge(user_id: current_user.id)
  end
end
