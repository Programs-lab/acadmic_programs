class AddDefaultToProcedureState < ActiveRecord::Migration[5.2]
  def change
  	change_column_default :procedures, :state, 0
  end
end
