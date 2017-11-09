class CreateQuestrades < ActiveRecord::Migration[5.0]
  def change
    create_table :questrades do |t|
      t.string :token

      t.timestamps
    end
  end
end
