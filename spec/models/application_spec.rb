require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it {should have_many :applications_pets}
    it {should have_many(:pets).through(:applications_pets)}
  end

  describe 'Instance Methods' do
    it '#add_pet creates a new row in the ApplicationsPets table' do
      shelter = Shelter.create!(name: "Denver Animal Rescue", city: "Denver", rank: 1, foster_program: true)
      pet = shelter.pets.create!(name: "Linus", breed: "Pitbull", age: 3, adoptable: true)

      application = Application.create!(name: "Aliya",
                                        street_address: "2525 Broad Street",
                                        city: "Denver",
                                        state: "CO",
                                        zip_code: 80218,
                                        description: "I love animals!",
                                        status: "Pending")

      expect(application.pets.length).to eq(0)

      application.add_pet(pet)

      expect(application.pets.length).to eq(1)
    end
  end
end
