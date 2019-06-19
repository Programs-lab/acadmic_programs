class AddsProcedureTypesArrayToWorkingWeeks < ActiveRecord::Migration[5.2]
  def change
    add_column :working_hours, :procedure_type_kinds, :string, array: true, default: []
  end
end
