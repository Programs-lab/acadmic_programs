class CreatesDocuments < ActiveRecord::Migration[5.2]
	def change
    create_table :documents do |t|
      t.string :template
      t.string :name
      t.text :description

      t.references :academic_process, foreign_key: true
      t.timestamps
    end
	end
end
