class CreateFaculties < ActiveRecord::Migration[5.2]
  def change
    create_table :faculties do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.timestamps
    end
  end
end
