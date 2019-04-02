class CreateProcedureType < ActiveRecord::Migration[5.2]
  def change
    create_table :procedure_types do |t|
      t.string :procedure_type_name, null: false
      t.decimal :cost, null: false, default: 0
      t.timestamps
    end
  end
end
