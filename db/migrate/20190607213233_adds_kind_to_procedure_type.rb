class AddsKindToProcedureType < ActiveRecord::Migration[5.2]
  def change
    add_column :procedure_types, :kind, :integer
  end
end
