class Application < ApplicationRecord
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true, numericality: true
  validates :description, presence: true, on: :update

  has_many :applications_pets, dependent: :destroy
  has_many :pets, through: :applications_pets, dependent: :destroy

  def add_pet(pet)
    pets << pet
  end

  def submittable?
    status == "In Progress" && pets.length != 0
  end

end
