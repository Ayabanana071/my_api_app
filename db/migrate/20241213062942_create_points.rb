class CreatePoints < ActiveRecord::Migration[8.0]
  def change
    create_table :points do |t|
      t.references :user, null: false, foreign_key: true  # ユーザーID
      t.integer :amount, null: false                     # 付与ポイント
      t.datetime :granted_at, null: false                # 付与日時

      t.timestamps
    end
  end
end
