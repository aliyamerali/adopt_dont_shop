require 'rails_helper'

RSpec.describe ApplicationsPet, type: :model do
  describe 'relationships' do
    it {should belong_to :application}
    it {should belong_to :pet}
  end

  before :each do
    @shelter = Shelter.create!(name: "Denver Animal Rescue", city: "Denver", rank: 1, foster_program: true)
    @pet = @shelter.pets.create!(name: "Linus", breed: "Pitbull", age: 3, adoptable: true)

    @application = Application.create!(name: "Aliya",
      street_address: "2525 Broad Street",
      city: "Denver",
      state: "CO",
      zip_code: 80218,
      description: "I love animals!",
      status: "Pending")

    @app_record = ApplicationsPet.create!(application_id: @application.id, pet_id: @pet.id)
  end

  describe 'class methods' do
    it '::apps_pets returns the pets for a given application' do
      expect(ApplicationsPet.apps_pets(@application.id).first.pet).to eq(@pet)
    end

    it '::record_lookup returns the ApplicationsPet record for a given application and ID' do
      expect(ApplicationsPet.record_lookup(@pet.id, @application.id)[0]).to eq(@app_record)
    end
  end
end
