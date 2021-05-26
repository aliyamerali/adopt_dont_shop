class AddStateToShelter < ActiveRecord::Migration[5.2]
  def change
    add_column :shelters, :state, :string
  end
end
