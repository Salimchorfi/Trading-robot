class CreateBtcs < ActiveRecord::Migration[5.0]
  def change
    create_table :btcs do |t|
      t.float :price

      t.timestamps
    end
  end
end
