class ApplicationsPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  scope :approved, -> {where("status = ?", "approved")}
  scope :approved_or_rejected, -> {where("status = ? or status = ?", "approved", "rejected")}

  def self.apps_pets(app_id)
    joins(:pet).where(application_id: app_id)
  end

  def self.record_lookup(pet, app)
    where(pet_id: pet, application_id: app)
  end
end
