class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :applications_pets, dependent: :destroy
  has_many :applications, through: :applications_pets, dependent: :destroy


  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def self.search_adoptable(name)
    where("adoptable = ? AND name ILIKE ?", true, "%#{name}%")
  end
end
