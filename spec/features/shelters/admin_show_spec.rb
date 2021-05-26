require 'rails_helper'

RSpec.describe 'the admin shelters index' do

  before :each do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pirate = @shelter.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @clawdia = @shelter.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @lucille = @shelter.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    @application_1 = @pirate.applications.create!(name: "Zahra",
                                street_address: "1000 Park Avenue",
                                city: "Longmont",
                                state: "CO",
                                zip_code: 80503,
                                description: "I've got a big backyard!",
                                status: "Pending")
    @application_2 = @clawdia.applications.create!(name: "Aliya",
                                  street_address: "2525 Broad Street",
                                  city: "Denver",
                                  state: "CO",
                                  zip_code: 80218,
                                  description: "I love animals!",
                                  status: "Pending")
    @application_2.pets << @lucille
    visit "/admin/shelters/#{@shelter.id}"
  end

  it 'shows the shelter name and address' do
    expect(page).to have_content(@shelter.name)
    expect(page).to have_content(@shelter.city)
  end

  describe 'statistics section' do
    it 'shows average age of all adoptable pets at that shelter' do
      within(".statistics") do
        expect(page).to have_content("Average Age of Adoptable Pets: 5.33")
      end
    end

    it 'shows number of pets at that shelter that are adoptable' do
      within(".statistics") do
        expect(page).to have_content("Count of Adoptable Pets: 3")
      end
    end

    it 'the number of pets that have been adopted from that shelter' do
      @application_1.update(status: "Approved")
      visit "/admin/shelters/#{@shelter.id}"

      within(".statistics") do
        expect(page).to have_content("Count of Pets Adopted from #{@shelter.name}: 1")
      end
    end
  end
end
