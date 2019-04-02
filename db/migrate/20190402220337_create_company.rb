class CreateCompany < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :company_name, null: false
      t.timestamps
    end
  end
end
