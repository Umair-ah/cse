class AddColumnPasswordDigestToGuide < ActiveRecord::Migration[7.0]
  def change
    add_column :guides, :password_digest, :string
  end
end
