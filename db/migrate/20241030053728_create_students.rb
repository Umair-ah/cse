class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :usn
      t.string :name
      t.references :batch, foreign_key: true

      t.timestamps
    end
  end
end
