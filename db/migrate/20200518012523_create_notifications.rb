class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :user
      t.string :type, default: ""
      t.integer :state, default: 0
      t.string :launch, default: ""
      t.text :message, default: ""
      t.string :title, default: ""
      t.timestamps
    end
  end
end
