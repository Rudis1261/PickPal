class Role < ApplicationRecord
  has_many :heroes
  validates_presence_of :name, :slug, :description
end
