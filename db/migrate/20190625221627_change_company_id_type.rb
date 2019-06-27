class ChangeCompanyIdType < ActiveRecord::Migration[5.2]
  def change
    change_column :companies, :company_id, :string
  end
end
