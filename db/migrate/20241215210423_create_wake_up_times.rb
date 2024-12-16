class CreateWakeUpTimes < ActiveRecord::Migration[8.0]
  def change
    create_table :wake_up_times do |t|
      t.integer :user_id, null: false # ユーザーID
      t.datetime :wake_up_time, null: false # 起床時間
      t.timestamps
    end

    # user_idにインデックスを追加
    add_index :wake_up_times, :user_id
  end
end
