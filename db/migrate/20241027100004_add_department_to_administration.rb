class AddDepartmentToAdministration < ActiveRecord::Migration[7.0]
  def change
    add_column :administrations, :department, :string
  end
end
