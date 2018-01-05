class AddIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :roles, :id
    add_index :stats, :id
  end
end
