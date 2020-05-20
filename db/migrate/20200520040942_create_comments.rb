class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
    	t.references :user
    	t.references :procedure_document
    	t.string :content, default: ""
    	t.timestamps
    end
  end
end
