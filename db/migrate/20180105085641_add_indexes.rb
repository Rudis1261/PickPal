class AddIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :roles, :id
  end
end
