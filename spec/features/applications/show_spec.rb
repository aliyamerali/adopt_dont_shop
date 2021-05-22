require 'rails_helper'

RSpec.describe "Application show page", type: :feature do
  before :each do
    @shelter = Shelter.create!(name: "Denver Animal Rescue", city: "Denver", rank: 1, foster_program: true)
    @application1 = Application.create!(name: "Aliya",
                                      street_address: "1243 N Lafayette",
                                      city: "Denver",
                                      state: "CO",
                                      zip_code: 80218,
                                      description: "I love animals!",
                                      status: "Pending")
    @application2 = Application.create!(name: "Tanner",
                                      street_address: "1241 N Lafayette",
                                      city: "Denver",
                                      state: "CO",
                                      zip_code: 80218,
                                      description: "Dogs are the best!",
                                      status: "In Progress")
    @alfalfa = Pet.create!(adoptable: true,
                            age: 3,
                            breed: "rescue special",
                            name: "Alfalfa",
                            shelter_id: @shelter.id)
    @alf = Pet.create!(adoptable: true,
                            age: 2,
                            breed: "great dane",
                            name: "Alf",
                            shelter_id: @shelter.id)
    @sprout = Pet.create!(adoptable: true,
                            age: 5,
                            breed: "lab mix",
                            name: "Sprout",
                            shelter_id: @shelter.id)

    ApplicationsPet.create!(pet: @alfalfa, application: @application1)
    ApplicationsPet.create!(pet: @sprout, application: @application1)

    visit "/applications/#{@application1.id}"
  end

  it 'shows the application attributes' do
    expect(page).to have_content(@application1.name)
    expect(page).to have_content(@application1.street_address)
    expect(page).to have_content(@application1.city)
    expect(page).to have_content(@application1.state)
    expect(page).to have_content(@application1.zip_code)
    expect(page).to have_content(@application1.description)
  end

  it 'shows the names of all associated pets, linking to pet show pages' do
    expect(page).to have_content(@alfalfa.name)
    expect(page).to have_link(@alfalfa.name, href: "/pets/#{@alfalfa.id}")
    expect(page).to have_content(@sprout.name)
    expect(page).to have_link(@sprout.name, href: "/pets/#{@sprout.id}")
  end

  it 'shows the application status' do
    expect(page).to have_content(@application1.status)
  end

  it 'does not show the ability to search pets if the application has been submitted' do
    visit "/applications/#{@application1.id}"

    expect(page).to_not have_content("Add a Pet to this Application")
  end

  it 'shows the functionality to search pets if the application is not submitted' do
    visit "/applications/#{@application2.id}"

    expect(page).to have_content("Add a Pet to this Application")
    expect(page).to have_field("Search")

    fill_in :search, with: "Alfalfa"
    click_on "Search"

    expect(page).to have_current_path("/applications/#{@application2.id}?utf8=✓&search=Alfalfa&commit=Search")
    expect(page).to have_content(@alfalfa.name)
    expect(page).to have_content(@alfalfa.age)
    expect(page).to have_content(@alfalfa.breed)
    expect(page).to have_content(@alfalfa.adoptable)
    expect(page).to have_content(@alfalfa.shelter.name)
  end

  it 'has the ability to add a pet to the application if the application is not submitted' do
    visit "/applications/#{@application2.id}"
    fill_in :search, with: "Alfalfa"
    click_on "Search"

    expect(page).to have_button("Adopt this Pet")
    click_on "Adopt this Pet"

    expect(page).to have_content("This Application's Pets:")
    expect(page).to have_content(@alfalfa.name)
    expect(page).to have_link(@alfalfa.name, href: "/pets/#{@alfalfa.id}")
  end

  it 'has the ability to submit an application if it is In Progress status and has at least one pet added' do
    visit "/applications/#{@application2.id}"
    expect(page).to_not have_button("Submit Application")
    expect(page).to have_content("Status: In Progress")

    fill_in :search, with: "Alfalfa"
    click_on "Search"
    click_on "Adopt this Pet"

    expect(page).to have_field("Why would you be a good home for a new pet?")
    fill_in :description, with: "I love dogs!"
    click_on "Submit Application"

    expect(page).to have_content("Status: Pending")
    expect(page).to have_content("This Application's Pets:")
    expect(page).to have_content(@alfalfa.name)
    expect(page).to have_content("Testimonial: I love dogs!")
    expect(page).to have_link(@alfalfa.name, href: "/pets/#{@alfalfa.id}")
    expect(page).to_not have_content("Add a Pet to this Application")
  end

  it 'does not show the option to submit if no pets are added' do
    visit "/applications/#{@application2.id}"

    expect(page).to have_content("Status: In Progress")
    expect(page).to_not have_button("Submit Application")
  end

  it 'returns partial matches on pet name searches' do
    visit "/applications/#{@application2.id}"

    fill_in :search, with: "Alf"
    click_on "Search"

    expect(page).to have_content(@alf.name)
    expect(page).to have_content(@alf.age)
    expect(page).to have_content(@alf.breed)
    expect(page).to have_content(@alf.adoptable)
    expect(page).to have_content(@alf.shelter.name)
    expect(page).to have_content(@alfalfa.name)
    expect(page).to have_content(@alfalfa.age)
    expect(page).to have_content(@alfalfa.breed)
    expect(page).to have_content(@alfalfa.adoptable)
    expect(page).to have_content(@alfalfa.shelter.name)
  end

  it 'returns case insensitive matches on pet name searches' do
    visit "/applications/#{@application2.id}"

    fill_in :search, with: "ALF"
    click_on "Search"
    expect(page).to have_content(@alf.name)
    expect(page).to have_content(@alfalfa.name)

    fill_in :search, with: "OUT"
    click_on "Search"    
    expect(page).to have_content(@sprout.name)
  end
end
