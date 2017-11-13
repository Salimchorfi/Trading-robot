class AddDataToBtcs < ActiveRecord::Migration[5.0]
  def change
    add_column :btcs, :index, :integer
  end
end
