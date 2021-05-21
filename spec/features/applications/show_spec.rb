require 'rails_helper'

RSpec.describe "Application show page", type: :feature do
  before :each do
    @application = Application.create!(name: "Aliya",
                                      street_address: "1243 N Lafayette",
                                      city: "Denver",
                                      state: "CO",
                                      zip_code: 80218,
                                      description: "I love animals!",
                                      status: "Pending")
    @alfalfa = Pet.create!(adoptable: true,
                            age: 3,
                            breed: "rescue special",
                            name: "Alfalfa",
                            shelter_id: 123)
    @sprout = Pet.create!(adoptable: true,
                            age: 5,
                            breed: "lab mix",
                            name: "Sprout",
                            shelter_id: 123)

    ApplicationsPet.create!(pet: @alfalfa, application: @application)
    ApplicationsPet.create!(pet: @sprout, application: @application)

    visit "/applications/#{application.id}"
  end

  it 'shows the application attributes' do
    expect(page).to have_content(@application.name)
    expect(page).to have_content(@application.street_address)
    expect(page).to have_content(@application.city)
    expect(page).to have_content(@application.state)
    expect(page).to have_content(@application.zip_code)
    expect(page).to have_content(@application.description)
  end

  it 'shows the names of all associated pets, linking to pet show pages' do
    expect(page).to have_content(@alfalfa.name)
    expect(page).to have_content(@sprout.name)
  end

  it 'shows the application status' do
    expect(page).to have_content(@application.status)
  end

end
