class CreateAbilities < ActiveRecord::Migration[5.1]
  def change
    create_table :abilities do |t|
      t.string :name
      t.string :description
      t.string :slug
      t.string :image
      t.belongs_to :hero, index: true

      t.timestamps
    end
    add_index :abilities, :belongs_to
  end
end
