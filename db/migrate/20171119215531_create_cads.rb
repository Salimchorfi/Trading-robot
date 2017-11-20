class CreateCads < ActiveRecord::Migration[5.0]
  def change
    create_table :cads do |t|
      t.integer :balance
      t.timestamps
    end
  end
end
