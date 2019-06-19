class CreatesWorkingHoursProcedureTypes < ActiveRecord::Migration[5.2]
  def change
      create_table :working_hours_procedure_types do |t|
      t.references :working_hour, foreign_key: true
      t.references :procedure_type, foreign_key: true
    end
  end
end
