class StudentsGuide < ApplicationRecord
  belongs_to :student, optional: true
  belongs_to :guide, optional: true
end
