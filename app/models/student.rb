class Student < ApplicationRecord
  belongs_to :batch, optional: true
  has_one :students_guide
  has_one :guide, through: :students_guide

  has_many :students_project
  has_many :projects, through: :students_project
  #has_one :guide
  # validates :usn, presence: true, uniqueness: true
  # validates :name, presence: true
end
