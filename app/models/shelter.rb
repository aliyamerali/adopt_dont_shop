class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.reverse_order_by_name
    find_by_sql('
      SELECT *
      FROM shelters
      ORDER BY name DESC')
  end

  def self.with_pending_apps_alpha
    joins(pets: :applications).where('applications.status'=> "Pending").distinct.order(:name)
  end

  def self.avg_age_adoptables(shelter_id)
    joins(:pets).where('pets.adoptable = ? and shelters.id = ?', true, shelter_id).average(:age).round(2)
  end

  def self.count_adoptables(shelter_id)
    Shelter.joins(:pets).where('pets.adoptable = ? and shelters.id = ?', true, shelter_id).count
  end

  def self.count_adopted(shelter_id)
    Shelter.joins(pets: :applications).where('applications.status = ? and shelters.id = ?', 'Approved', shelter_id).count
  end

  def self.pets_with_pending(shelter_id)
    Shelter.select('pets.name AS pet_name, applications.id AS app_id').joins(pets: :applications).where('applications.status = ? and shelters.id = ?', 'Pending', shelter_id)
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

end
