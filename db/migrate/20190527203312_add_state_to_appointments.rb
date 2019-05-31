class AddStateToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :state, :integer
  end
end
