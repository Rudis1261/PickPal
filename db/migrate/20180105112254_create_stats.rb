class CreateStats < ActiveRecord::Migration[5.1]
  def change
    create_table :stats do |t|
      t.integer :damage, limit: 2
      t.integer :utility, limit: 2
      t.integer :survivability, limit: 2
      t.integer :complexity, limit: 2

      t.timestamps
    end
  end
end
