require 'rails_helper'

RSpec.describe 'the admin shelters index' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
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

    visit '/admin/shelters'
  end

  it 'lists all shelters in the system in reverse alphabetical order by name' do
    expect(page).to have_content(@shelter_1.name)
    expect(page).to have_content(@shelter_2.name)
    expect(page).to have_content(@shelter_3.name)

    expect(@shelter_2.name).to appear_before(@shelter_3.name)
    expect(@shelter_3.name).to appear_before(@shelter_1.name)
  end

  it 'links to each shelter admin show page' do
    expect(page).to have_link(@shelter_1.name, href: "/admin/shelters/#{@shelter_1.id}")
    expect(page).to have_link(@shelter_2.name, href: "/admin/shelters/#{@shelter_2.id}")
    expect(page).to have_link(@shelter_3.name, href: "/admin/shelters/#{@shelter_3.id}")

    click_link(@shelter_1.name)
    expect(page).to have_current_path("/admin/shelters/#{@shelter_1.id}")
  end

  it 'has a section for shelters with pending applications' do
    expect(page).to have_content("Shelters with Pending Applications")
    within('.shelters-with-pending') do
      expect(page).to have_content(@shelter_1.name)
      expect(page).to_not have_content(@shelter_2.name)
      expect(page).to_not have_content(@shelter_3.name)
    end
    @lucille.applications.create!(name: "Aliya",
                                      street_address: "2525 Broad Street",
                                      city: "Denver",
                                      state: "CO",
                                      zip_code: 80218,
                                      description: "I love animals!",
                                      status: "Pending")

    visit '/admin/shelters'

    within('.shelters-with-pending') do
      expect(page).to have_content(@shelter_1.name)
      expect(page).to have_content(@shelter_3.name)
      expect(page).to_not have_content(@shelter_2.name)
    end
  end
end
