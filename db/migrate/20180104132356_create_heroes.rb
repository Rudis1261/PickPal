class CreateHeroes < ActiveRecord::Migration[5.1]
  def change
    create_table :heroes do |t|
      t.string :title
      t.string :name
      t.string :slug
      t.string :poster_image
      t.string :description
      t.string :type_of_hero
      t.string :franchise, index: true
      t.string :difficulty
      t.string :thumb
      t.boolean :live
      t.belongs_to :role, index: true
      t.belongs_to :stat, index: true

      t.timestamps
    end
  end
end
