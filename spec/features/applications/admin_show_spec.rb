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
    @application2 = @pirate.applications.create!(name: "Liz Lemon",
                                      street_address: "234 Broadway",
                                      city: "NYC",
                                      state: "NY",
                                      zip_code: 11234,
                                      description: "I live by a park",
                                      status: "Pending")
    @application.pets << @clawdia
    @application.pets << @lucille

    visit "/admin/applications/#{@application.id}"
  end

  it 'for every adoptable pet that the application is for, there are buttons to approve or reject' do
    within('.MrPirate') do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
    within(".Clawdia") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
    within(".LucilleBald") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  it 'for a not-adoptable pet that the application is for, there is a note and a button to reject' do
    @pirate.update(adoptable: false)
    @lucille.update(adoptable: false)

    within('.MrPirate') do
      expect(page).to have_content("Approved for adoption with another applicant.")
      expect(page).to have_button("Reject")
    end
    within(".Clawdia") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
      expect(page).to_not have_content("Approved for adoption with another applicant.")
    end
    within(".LucilleBald") do
      expect(page).to have_content("Approved for adoption with another applicant.")
      expect(page).to have_button("Reject")
    end
  end

  it 'upon selecting "Approve", page refreshes with status approved and no option to approve again' do
    within('.MrPirate') do
      click_button("Approve")
    end

    within('.MrPirate') do
      expect(page).to have_content("Application approved for this pet")
      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
    end
    within(".Clawdia") do
      expect(page).to have_button("Approve")
    end
    within(".LucilleBald") do
      expect(page).to have_button("Approve")
    end
  end

  it 'upon selecting "Reject", page refreshes with status rejected and no option to approve again' do
    within('.MrPirate') do
      click_button("Reject")
    end

    within('.MrPirate') do
      expect(page).to have_content("Application rejected for this pet")
      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
    end
    within(".Clawdia") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
    within(".LucilleBald") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  it 'updates status of application\'s pets for that application only' do
    within('.MrPirate') do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end

    visit "/admin/applications/#{@application2.id}"
    within('.MrPirate') do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end

    visit "/admin/applications/#{@application.id}"
    within('.MrPirate') do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
      click_button("Reject")
      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
    end

    visit "/admin/applications/#{@application2.id}"
    within('.MrPirate') do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  it 'updates app status to approved if all pets are approved and marks pets as not adoptable' do
    expect(page).to have_content("Status: Pending")
    expect(@pirate.adoptable).to eq(true)
    expect(@clawdia.adoptable).to eq(true)
    expect(@lucille.adoptable).to eq(true)

    within('.MrPirate') do
      click_button("Approve")
    end

    within(".Clawdia") do
      click_button("Approve")
    end

    expect(@pirate.reload.adoptable).to eq(true)
    expect(@clawdia.reload.adoptable).to eq(true)
    expect(@lucille.reload.adoptable).to eq(true)

    within(".LucilleBald") do
      click_button("Approve")
    end

    expect(@pirate.reload.adoptable).to eq(false)
    expect(@clawdia.reload.adoptable).to eq(false)
    expect(@lucille.reload.adoptable).to eq(false)

    expect(page).to have_current_path("/admin/applications/#{@application.id}")
    expect(page).to have_content("Status: Approved")
    expect(@application.reload.status).to eq("Approved")
  end

  it 'updates the app status to rejected if all pets are approved/rejected, with at least one rejection' do
    expect(page).to have_content("Status: Pending")

    within('.MrPirate') do
      click_button("Approve")
    end

    expect(page).to have_content("Status: Pending")

    within(".Clawdia") do
      click_button("Reject")
    end

    expect(page).to have_content("Status: Pending")

    within(".LucilleBald") do
      click_button("Approve")
    end

    expect(page).to have_current_path("/admin/applications/#{@application.id}")
    expect(page).to have_content("Status: Rejected")
    expect(@application.reload.status).to eq("Rejected")

  end
end
