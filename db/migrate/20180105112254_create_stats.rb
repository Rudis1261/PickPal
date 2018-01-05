class CreateStats < ActiveRecord::Migration[5.1]
  def change
    create_table :stats do |t|
      t.integer :damage, limit: 2, default: 0
      t.integer :utility, limit: 2, default: 0
      t.integer :survivability, limit: 2, default: 0
      t.integer :complexity, limit: 2, default: 0
      t.belongs_to :hero, index: true

      t.timestamps
    end
  end
end
