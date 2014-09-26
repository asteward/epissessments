class Requirement < ActiveRecord::Base
  validates_presence_of :content

  belongs_to :assessment
  has_one :grade
end
