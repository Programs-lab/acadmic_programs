class SetDefaultValuesAcademicProcesses < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:academic_processes, :year_saces, 0)
    change_column_default(:academic_processes, :month_saces, 0)
    change_column_default(:academic_processes, :day_saces, 0)
    change_column_default(:academic_processes, :year_academic_council, 0)
    change_column_default(:academic_processes, :month_academic_council, 0)
    change_column_default(:academic_processes, :day_academic_council, 0)
  end
end
