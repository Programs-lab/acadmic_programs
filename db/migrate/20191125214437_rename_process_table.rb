class RenameProcessTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :processes, :academic_processes
  end
end
