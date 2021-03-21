class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, index: { unique: true }, null: false
      t.text :description, null: false
      t.decimal :price, :precision => 8, :scale => 2, null: false

      t.timestamps
    end
  end
end
