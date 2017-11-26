class CreateEthBalances < ActiveRecord::Migration[5.0]
  def change
    create_table :eth_balances do |t|
      t.float :balance

      t.timestamps
    end
  end
end
