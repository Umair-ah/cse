class CreateStudentsGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :students_guides do |t|
      t.belongs_to :student, foreign_key: true
      t.belongs_to :guide, foreign_key: true

      t.timestamps
    end
  end
end
