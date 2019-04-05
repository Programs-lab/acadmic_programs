class CreateMedicalRecord < ActiveRecord::Migration[5.2]
  def change
    create_table :medical_records do |t|
      t.references :patient, references: :users, null: false
      t.timestamps
    end
  end
end
