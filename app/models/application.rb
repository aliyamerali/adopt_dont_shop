class Application < ApplicationRecord
  has_many :applications_pets, dependent: :destroy
  has_many :pets, through: :applications_pets, dependent: :destroy
  
end
