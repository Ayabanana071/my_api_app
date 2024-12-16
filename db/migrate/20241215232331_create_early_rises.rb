class CreateEarlyRises < ActiveRecord::Migration[8.0]
  def change
    create_table :early_rises do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :wake_up_time, null: false
      t.datetime :cleared_at
      t.string :status, null: false, default: "未設定"

      t.timestamps
    end
  end
end
