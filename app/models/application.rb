class Application < ApplicationRecord
  has_many :applications_pets
  has_many :pets, through: :applications_pets
end
