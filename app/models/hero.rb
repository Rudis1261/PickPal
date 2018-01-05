class Hero < ApplicationRecord
  belongs_to :role
  has_one :stat, dependent: :destroy
end
