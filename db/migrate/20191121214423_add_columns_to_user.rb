class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :academic_program, index: true
    add_column :users, :modality, :string
  end
end
