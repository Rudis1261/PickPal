class CreateHeroes < ActiveRecord::Migration[5.1]
  def change
    create_table :heroes do |t|
      t.string :title
      t.string :name
      t.string :slug
      t.string :poster_image

      t.timestamps
    end
  end
end
