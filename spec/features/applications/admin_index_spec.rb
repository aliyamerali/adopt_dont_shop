require 'rails_helper'

RSpec.describe 'the admin applications index' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pirate = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @clawdia = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @lucille = @shelter_1.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    @application1 = @pirate.applications.create!(name: "Zahra",
                                      street_address: "1000 Park Avenue",
                                      city: "Longmont",
                                      state: "CO",
                                      zip_code: 80503,
                                      description: "I've got a big backyard!",
                                      status: "Pending")
    @application2 = @pirate.applications.create!(name: "Liz Lemon",
                                      street_address: "234 Broadway",
                                      city: "NYC",
                                      state: "NY",
                                      zip_code: 11234,
                                      description: "I live by a park",
                                      status: "Pending")
    @application3 = @pirate.applications.create!(name: "Jack Donaghy",
                                      street_address: "4567 Lexington Ave",
                                      city: "NYC",
                                      state: "NY",
                                      zip_code: 11234,
                                      description: "I live by a park",
                                      status: "In Progress")

    visit "/admin/applications"
  end

  it 'lists all applications in the system' do
    expect(page).to have_content(@application1.id)
    expect(page).to have_content(@application2.id)
    expect(page).to have_content(@application3.id)
    expect(page).to have_content(@application1.name)
    expect(page).to have_content(@application2.name)
    expect(page).to have_content(@application3.name)
    expect(page).to have_content(@application1.city)
    expect(page).to have_content(@application2.city)
    expect(page).to have_content(@application3.city)
    expect(page).to have_content(@application1.state)
    expect(page).to have_content(@application2.state)
    expect(page).to have_content(@application3.state)
    expect(page).to have_content(@application1.status)
    expect(page).to have_content(@application2.status)
    expect(page).to have_content(@application3.status)
  end

  it 'links to each application admin show page' do
    expect(page).to have_link(@application1.id, href: "/admin/applications/#{@application1.id}")
    expect(page).to have_link(@application2.id, href: "/admin/applications/#{@application2.id}")
    expect(page).to have_link(@application3.id, href: "/admin/applications/#{@application3.id}")

    click_link(@application1.id)
    expect(page).to have_current_path("/admin/applications/#{@application1.id}")
  end

end
