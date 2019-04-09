class AddCompanyIdAndProcedureDuration < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :company_id, :integer, null: false, unique: true
    add_column :procedure_types, :procedure_duration, :integer, null: false
  end
end
