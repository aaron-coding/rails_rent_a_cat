class AddCatOwnerToCat < ActiveRecord::Migration
  def change
    add_column :cats, :user_id, :integer
    change_column :cats, :user_id, :integer, default: 1, null: false

  end
end
