class CreateTitres < ActiveRecord::Migration[5.0]
  def change
    create_table :titres do |t|
      t.string :symbol
      t.integer :quantity

      t.timestamps
    end
  end
end
