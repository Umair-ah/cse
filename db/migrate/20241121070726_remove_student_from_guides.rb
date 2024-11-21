class RemoveStudentFromGuides < ActiveRecord::Migration[7.0]
  def change
    remove_reference :guides, :student, foreign_key: true
  end
end
