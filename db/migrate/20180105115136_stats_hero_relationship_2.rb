class StatsHeroRelationship2 < ActiveRecord::Migration[5.1]
  def change
    change_table :heroes do |t|
      t.belongs_to :stat, index: true
    end

    remove_column :heroes, :stats_id
  end
end
