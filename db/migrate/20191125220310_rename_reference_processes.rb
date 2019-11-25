class RenameReferenceProcesses < ActiveRecord::Migration[5.2]
  def change
    rename_column :processes_academic_programs, :process_id, :academic_process_id
  end
end
