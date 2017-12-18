class CreateTrades < ActiveRecord::Migration[5.0]
  def change
    create_table :trades do |t|
      t.string :symbol
      t.float :price
      t.string :action
      t.float :quantity

      t.timestamps
    end
  end
end
