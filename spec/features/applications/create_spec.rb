require 'rails_helper'

RSpec.describe "create new application", type: :feature do
  it 'has a form with fields for creating an application' do
    visit '/applications/new'

    expect(page).to have_field(:name)
    expect(page).to have_field(:street_address)
    expect(page).to have_field(:city)
    expect(page).to have_field(:state)
    expect(page).to have_field(:zip_code)
    expect(page).to have_field(:description)
  end

  it 'takes you to the applications show page where I see the application details' do
    visit '/applications/new'

    fill_in :name, with: 'Aliya Merali'
    fill_in :street_address, with: '123 Maple St'
    fill_in :city, with: 'Boulder'
    fill_in :state, with: 'CO'
    fill_in :zip_code, with: '80902'
    fill_in :description, with: 'Doggos are the best!'

    click_on "Apply"

    expect(page).to have_current_path("/applications/#{Application.last.id}")
    expect(page).to have_content("Aliya Merali")
    expect(page).to have_content("123 Maple St")
    expect(page).to have_content("Boulder")
    expect(page).to have_content("CO")
    expect(page).to have_content("80902")
    expect(page).to have_content("In Progress")
    expect(page).to have_content("Doggos are the best!")
  end
end
