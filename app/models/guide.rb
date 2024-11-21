class Guide < ApplicationRecord

  has_many :students_guide
  has_many :students, through: :students_guide
end
