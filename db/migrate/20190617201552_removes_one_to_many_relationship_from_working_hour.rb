class RemovesOneToManyRelationshipFromWorkingHour < ActiveRecord::Migration[5.2]
  def change
    remove_column :working_hours, :procedure_type_id
  end
end
