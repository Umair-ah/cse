class Batch < ApplicationRecord
  
  has_many :students, dependent: :destroy
end
