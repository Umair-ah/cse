class Project < ApplicationRecord
  belongs_to :student

  has_many :students_project, dependent: :destroy
  has_many :students, through: :students_project, dependent: :destroy

  validates :mark1, :mark2, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5, 
    message: "should be between 0 and 5" }

  validates :mark3, :mark4, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, 
    message: "should be between 0 and 10" }

  validates :mark5, :mark6, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10, 
    message: "should be between 0 and 10" }

  validates :mark7, :mark8, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 20, 
    message: "should be between 0 and 20" }

  validates :mark9, :mark10, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5, 
    message: "should be between 0 and 5" }

  after_save :calc_total

  def calc_total
    t1 = ((self.mark1 + self.mark2)/2)
    t2 = ((self.mark3 + self.mark4)/2)
    t3 = ((self.mark5 + self.mark6)/2)
    t4 = ((self.mark7 + self.mark8)/2)
    t5 = ((self.mark9 + self.mark10)/2)
    total_of_all = t1 + t2 + t3 + t4 + t5

    update_column(:total, total_of_all)

    if self.title == "Mini Project"
      student.update(mini: total_of_all) if student.present?
    elsif self.title == "Major Project"
      student.update(major: total_of_all) if student.present?
    end

  end
end
