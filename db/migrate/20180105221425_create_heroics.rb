class CreateHeroics < ActiveRecord::Migration[5.1]
  def change
    create_table :heroics do |t|
      t.string :name
      t.string :description
      t.string :slug
      t.string :image
      t.belongs_to :hero, index: true

      t.timestamps
    end
    add_index :heroics, :belongs_to
  end
end
