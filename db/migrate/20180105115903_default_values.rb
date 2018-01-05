class DefaultValues < ActiveRecord::Migration[5.1]
  def change
    change_column_default :stats, :damage, 0
    change_column_default :stats, :utility, 0
    change_column_default :stats, :survivability, 0
    change_column_default :stats, :complexity, 0
  end
end
