class CreateProcedures < ActiveRecord::Migration[5.2]
  def change
    create_table :procedures do |t|
    	t.date :procedure_date
    	t.integer :state
    	t.references :processes_academic_program
      t.timestamps
    end
  end
end
