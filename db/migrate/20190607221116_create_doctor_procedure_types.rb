class CreateDoctorProcedureTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :doctor_procedure_types do |t|
      t.references :doctor, references: :users, null: false
      t.references :procedure_types, foreign_key: true
    end
  end
end
