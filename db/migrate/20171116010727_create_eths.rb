class CreateEths < ActiveRecord::Migration[5.0]
  def change
    create_table :eths do |t|
      t.float :price
      t.integer :index

      t.timestamps
    end
  end
end
