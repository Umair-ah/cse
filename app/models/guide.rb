class Guide < ApplicationRecord
  has_secure_password

  has_many :students_guide, dependent: :destroy
  has_many :students, through: :students_guide, dependent: :destroy
end
