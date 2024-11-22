class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.decimal :mark1, scale: 1, precision: 3
      t.decimal :mark2, scale: 1, precision: 3
      t.decimal :mark3, scale: 1, precision: 3
      t.decimal :mark4, scale: 1, precision: 3
      t.decimal :mark5, scale: 1, precision: 3
      t.decimal :mark6, scale: 1, precision: 3
      t.decimal :mark7, scale: 1, precision: 3
      t.decimal :mark8, scale: 1, precision: 3
      t.decimal :mark9, scale: 1, precision: 3
      t.decimal :mark10, scale: 1, precision: 3
      t.decimal :total, scale: 1, precision: 3
      t.belongs_to :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
