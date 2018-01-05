class UpdateHeroStructure1 < ActiveRecord::Migration[5.1]
  def change
    change_table :heroes do |t|
      # t.string :title
      t.string :description
      t.string :type_of_hero
      t.string :franchise, index: true
      t.string :difficulty
      t.boolean :live
      t.belongs_to :role, index: true
    end
  end
end
