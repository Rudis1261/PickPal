class StatsHeroRelationship < ActiveRecord::Migration[5.1]
  def change
    change_table :stats do |t|
      t.belongs_to :hero, index: true
    end
  end
end
