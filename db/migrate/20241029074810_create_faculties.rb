class CreateFaculties < ActiveRecord::Migration[7.0]
  def change
    create_table :faculties do |t|
      t.string :name
      t.string :position
      t.string :degree
      t.string :aicte_id
      t.string :mail
      t.string :experience

      t.timestamps
    end
  end
end
