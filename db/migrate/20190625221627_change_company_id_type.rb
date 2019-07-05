class ChangeCompanyIdType < ActiveRecord::Migration[5.2]
  def up
    change_column :companies, :company_id, :string
  end

  def down
    change_column :companies, :company_id, :integer
  end
end
