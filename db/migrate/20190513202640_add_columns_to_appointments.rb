class AddColumnsToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :disabled, :boolean, default: false, null: false
    add_column :appointments, :attended, :boolean, default: false, null: false
  end
end
