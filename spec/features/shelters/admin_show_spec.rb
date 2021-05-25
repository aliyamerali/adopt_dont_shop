require 'rails_helper'

RSpec.describe 'the admin shelters index' do

  before :each do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'AAA Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @pirate = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @clawdia = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @lucille = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    @pirate.applications.create!(name: "Zahra",
                                street_address: "1000 Park Avenue",
                                city: "Longmont",
                                state: "CO",
                                zip_code: 80503,
                                description: "I've got a big backyard!",
                                status: "Pending")
    @lucille.applications.create!(name: "Aliya",
                                  street_address: "2525 Broad Street",
                                  city: "Denver",
                                  state: "CO",
                                  zip_code: 80218,
                                  description: "I love animals!",
                                  status: "Pending")
  end

  it 'shows the shelter name and address' do
    visit "/admin/shelters/#{@shelter_1.id}"
    expect(page).to have_content(@shelter_1.name)
    expect(page).to have_content(@shelter_1.city)

    visit "/admin/shelters/#{@shelter_2.id}"
    expect(page).to have_content(@shelter_2.name)
    expect(page).to have_content(@shelter_2.city)

    visit "/admin/shelters/#{@shelter_3.id}"
    expect(page).to have_content(@shelter_3.name)
    expect(page).to have_content(@shelter_3.city)
  end
end
