class CreateProcedureCompany < ActiveRecord::Migration[5.2]
  def change
    create_table :procedure_companies do |t|
      t.decimal :cost, null: false, default: 0
      t.references :company, null: false, foreign_key: true
      t.references :procedure_type, null: false, foreign_key: true
      t.timestamps
    end
  end
end
