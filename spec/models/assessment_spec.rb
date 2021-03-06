require 'rails_helper'

RSpec.describe Assessment, :type => :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :section }
  it { should validate_presence_of :url }
  it { should have_many :requirements }

  describe ".graded_by_assessment" do
    it "returns a hash of the number of graded assessments" do
      assessment1 = Assessment.create(title: "first", section: "1", url: "one.com")
      assessment2 = Assessment.create(title: "second", section: "2", url: "two.com")
      submission1a = Submission.create(link: "submission.com", assessment_id: assessment1.id, graded: true)
      submission1b = Submission.create(link: "submission.com", assessment_id: assessment1.id, graded: true)
      submission2a = Submission.create(link: "submission.com", assessment_id: assessment2.id, graded: true)
      submission2b = Submission.create(link: "submission.com", assessment_id: assessment2.id)
      result = {"first" => 2, "second" => 1}
      expect(Assessment.graded_by_assessment).to eq result
    end
  end

  describe ".analysis_by_assessment" do
    it "returns an array of hashes of data about assessments" do
      assessment1 = Assessment.create(title: "first", section: "1", url: "one.com")
      assessment2 = Assessment.create(title: "second", section: "2", url: "two.com")
      submission1a = Submission.create(link: "submission.com", assessment_id: assessment1.id, graded: true)
      submission1b = Submission.create(link: "submission.com", assessment_id: assessment1.id, graded: true)
      submission2a = Submission.create(link: "submission.com", assessment_id: assessment2.id, graded: true)
      submission2b = Submission.create(link: "submission.com", assessment_id: assessment2.id)
      result = [{"name" => "submitted", "data" => {"first" => 2, "second" => 2}}, {"name" => "graded", "data" => {"first" => 2, "second" => 1}}]
      expect(Assessment.analysis_by_assessment).to eq result
    end
  end
end
