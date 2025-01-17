require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @app_1 = @pet_1.applications.create!(name: "Aliya",
                                street_address: "2525 Broad Street",
                                city: "Denver",
                                state: "CO",
                                zip_code: 80218,
                                description: "I love animals!",
                                status: "Pending")
    @app_2 = @pet_2.applications.create!(name: "John",
                                street_address: "1000 Park Avenue",
                                city: "Boulder",
                                state: "CO",
                                zip_code: 80503,
                                description: "I've got a big backyard!",
                                status: "Pending")
    @app_3 = @pet_3.applications.create!(name: "Zahra",
                                street_address: "1000 Park Avenue",
                                city: "Longmont",
                                state: "CO",
                                zip_code: 80503,
                                description: "I've got a big backyard!",
                                status: "Pending")
  end

  describe 'class methods' do
    describe '::search' do
      it 'returns partial matches' do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe '::order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '::order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe '::reverse_order_by_name' do
      it 'orders shelters by name in reverse alphabetical order' do
        expect(Shelter.reverse_order_by_name).to eq([@shelter_2, @shelter_3, @shelter_1])
      end
    end

    describe '::with_pending_apps_alpha' do
      it 'returns distinct shelters with pending applications sorted alphabetically' do
        expect(Shelter.with_pending_apps_alpha).to eq([@shelter_1, @shelter_3])
      end
    end

    describe '::avg_age_adoptables' do
      it 'returns the average age of pets that are adoptable at a given shelter' do
        expect(Shelter.avg_age_adoptables(@shelter_1.id)).to eq(4)
      end
    end

    describe '::count_adoptables' do
      it 'returns the total count of pets that are adoptable at a given shelter' do
        expect(Shelter.count_adoptables(@shelter_1.id)).to eq(2)
      end
    end

    describe '::count_adopted' do
      it 'returns the number of pets adopted from a shelter' do
        expect(Shelter.count_adopted(@shelter_1.id)).to eq(0)
      end
    end

    describe '::pets_with_pending' do
      it 'returns the names and application id#s of pets with pending apps at a given shelter' do
        expect(Shelter.pets_with_pending(@shelter_1.id).length).to eq(2)
        expect(Shelter.pets_with_pending(@shelter_1.id).first.app_id).to eq(@app_1.id)
        expect(Shelter.pets_with_pending(@shelter_1.id).first.pet_name).to eq(@pet_1.name)
        expect(Shelter.pets_with_pending(@shelter_1.id).second.app_id).to eq(@app_2.id)
        expect(Shelter.pets_with_pending(@shelter_1.id).second.pet_name).to eq(@pet_2.name)
      end
    end
  end

  describe 'instance methods' do
    describe '#adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '#alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '#shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '#pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

  end
end
