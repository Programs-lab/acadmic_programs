class AddUniquenessToUserId < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :id_number, unique: true
  end
end
