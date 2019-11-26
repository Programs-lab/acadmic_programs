class AddResolutionToProccesses < ActiveRecord::Migration[5.2]
  def change
    add_column :processes_academic_programs, :resolution, :string
  end
end
