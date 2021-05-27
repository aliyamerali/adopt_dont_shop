require 'rails_helper'

RSpec.describe ApplicationsPet, type: :model do
  describe 'relationships' do
    it {should belong_to :application}
    it {should belong_to :pet}
  end

  before :each do
    @shelter = Shelter.create!(name: "Denver Animal Rescue", city: "Denver", rank: 1, foster_program: true)
    @pet = @shelter.pets.create!(name: "Linus", breed: "Pitbull", age: 3, adoptable: true)
    @pet2 = @shelter.pets.create!(name: "Charlie", breed: "Golden Retreiever", age: 5, adoptable: true)

    @application = Application.create!(name: "Aliya",
      street_address: "2525 Broad Street",
      city: "Denver",
      state: "CO",
      zip_code: 80218,
      description: "I love animals!",
      status: "Pending")

    @app_record = ApplicationsPet.create!(application_id: @application.id, pet_id: @pet.id, status: "approved")
    ApplicationsPet.create!(application_id: @application.id, pet_id: @pet2.id, status: "rejected")
  end

  describe 'scopes' do
    it ':approved returns applicationspets records w/ status approved' do
      @apps_pets = ApplicationsPet.apps_pets(@application.id)
      expect(@apps_pets.approved.count).to eq(1)
      expect(@apps_pets.approved.first).to eq(@app_record)
    end

    it ':approved_or_rejected returns applicationspets records w/ status approved or rejected' do
      @apps_pets = ApplicationsPet.apps_pets(@application.id)
      expect(@apps_pets.approved_or_rejected.count).to eq(2)
      expect(@apps_pets.approved_or_rejected.first).to eq(@apps_pets.first)
      expect(@apps_pets.approved_or_rejected.last).to eq(@apps_pets.last)
    end
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
