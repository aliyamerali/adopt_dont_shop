require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it {should have_many :applications_pets}
    it {should have_many(:pets).through(:applications_pets)}
  end
end
