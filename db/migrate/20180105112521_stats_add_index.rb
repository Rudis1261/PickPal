class StatsAddIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :stats, :id
    change_table :heroes do |t|
      t.belongs_to :stats, index: true
    end
  end
end
