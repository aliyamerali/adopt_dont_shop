require 'rails_helper'

RSpec.describe 'the admin shelters index' do

  before :each do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9, street_address: '123 Colfax Ave', zip_code: 80222, state: "CO")
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @pirate = @shelter.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @clawdia = @shelter.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @lucille = @shelter_2.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

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
    @application_3 = @clawdia.applications.create!(name: "John Denver",
                                  street_address: "2342 Maple Street",
                                  city: "Boulder",
                                  state: "CO",
                                  zip_code: 80209,
                                  description: "I love animals!",
                                  status: "Pending")
    @application_2.pets << @lucille
    visit "/admin/shelters/#{@shelter.id}"
  end

  it 'shows the shelters name and full address' do
    expect(page).to have_content(@shelter.name)
    expect(page).to have_content(@shelter.street_address)
    expect(page).to have_content(@shelter.city)
    expect(page).to have_content(@shelter.state)
    expect(page).to have_content(@shelter.zip_code)
  end

  describe 'statistics section' do
    it 'shows average age of all adoptable pets at that shelter' do
      within(".statistics") do
        expect(page).to have_content("Average Age of Adoptable Pets: 4")
      end
    end

    it 'shows number of pets at that shelter that are adoptable' do
      within(".statistics") do
        expect(page).to have_content("Count of Adoptable Pets: 2")
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

  describe 'action required section' do
    it 'shows a list of pets at the shelter that have pending applications' do
      within(".action_required") do
        expect(page).to have_content(@pirate.name)
        expect(page).to have_content(@clawdia.name)
      end
    end

    it 'links to the admin/application show page(s) to accept or reject the pet' do
      within(".action_required") do
        expect(page).to have_link("Application #{@application_1.id}", href: "/admin/applications/#{@application_1.id}")
        expect(page).to have_link("Application #{@application_2.id}", href: "/admin/applications/#{@application_2.id}")
        expect(page).to have_link("Application #{@application_3.id}", href: "/admin/applications/#{@application_3.id}")
      end
    end
  end
end
