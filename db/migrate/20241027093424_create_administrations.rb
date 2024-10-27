class CreateAdministrations < ActiveRecord::Migration[7.0]
  def change
    create_table :administrations do |t|
      t.string :name
      t.string :degree
      t.string :position

      t.timestamps
    end
  end
end
