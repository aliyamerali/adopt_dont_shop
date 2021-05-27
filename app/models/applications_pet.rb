class ApplicationsPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def self.apps_pets(app_id)
    joins(:pet).where(application_id: app_id)
  end

end
