class AddExplicitUrlToMedium < ActiveRecord::Migration[5.2]
  def change
    add_column :media, :url, :string
  end
end
