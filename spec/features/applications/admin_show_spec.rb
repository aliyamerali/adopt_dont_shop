require 'rails_helper'

RSpec.describe 'Applications admin show page', type: :feature do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pirate = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @clawdia = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @lucille = @shelter_1.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    @application = @pirate.applications.create!(name: "Zahra",
                                      street_address: "1000 Park Avenue",
                                      city: "Longmont",
                                      state: "CO",
                                      zip_code: 80503,
                                      description: "I've got a big backyard!",
                                      status: "Pending")
    @application.pets << @clawdia
    @application.pets << @lucille

    visit "/admin/applications/#{@application.id}"
  end

  it 'shows a button for every pet that the application is for, there is a button to approve' do
    within('.MrPirate') do
      expect(page).to have_button("Approve")
    end
    within(".Clawdia") do
      expect(page).to have_button("Approve")
    end
    within(".LucilleBald") do
      expect(page).to have_button("Approve")
    end
  end

  it 'upon selecting "Approve", page refreshes with status approved and no option to approve again' do
    within('.MrPirate') do
      click_button("Approve")
    end

    within('.MrPirate') do
      expect(page).to have_content("Application approved for this pet")
    end
    within(".Clawdia") do
      expect(page).to have_button("Approve")
    end
    within(".LucilleBald") do
      expect(page).to have_button("Approve")
    end

  end
end
