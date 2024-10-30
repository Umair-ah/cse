class Student < ApplicationRecord
  belongs_to :batch
  # validates :usn, presence: true, uniqueness: true
  # validates :name, presence: true
end
