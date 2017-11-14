class CreateRegressions < ActiveRecord::Migration[5.0]
  def change
    create_table :regressions do |t|
      t.float :slope
      t.float :rsquared

      t.timestamps
    end
  end
end
