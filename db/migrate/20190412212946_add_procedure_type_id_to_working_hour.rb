class AddProcedureTypeIdToWorkingHour < ActiveRecord::Migration[5.2]
  def change
    add_reference :working_hours, :procedure_type, index: true, null: false
  end
end
