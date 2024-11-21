class Student < ApplicationRecord
  belongs_to :batch, optional: true
  has_one :students_guide
  has_one :guide, through: :students_guide
  #has_one :guide
  # validates :usn, presence: true, uniqueness: true
  # validates :name, presence: true
end
