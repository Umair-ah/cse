class AddMiniAndMajorToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :mini, :decimal, scale: 1, precision: 3
    add_column :students, :major, :decimal, scale: 1, precision: 3
  end
end
