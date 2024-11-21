class CreateGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :guides do |t|
      t.string :name
      t.belongs_to :student, foreign_key: true

      t.timestamps
    end
  end
end
