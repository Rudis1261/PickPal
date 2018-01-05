class Hero < ApplicationRecord
  belongs_to :role
  has_one :stat, dependent: :destroy
  has_many :heroic, dependent: :destroy
  has_many :ability, dependent: :destroy
end
