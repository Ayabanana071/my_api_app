class CreateClearMissions < ActiveRecord::Migration[7.0]
  def change
    create_table :clear_missions do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :completed_missions_count, default: 0, null: false
      t.integer :total_points, default: 0, null: false

      t.timestamps
    end

    # ユニークインデックスで1日1レコード制約
    add_index :clear_missions, [:user_id, :date], unique: true
  end
end
