class CreateTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :tokens do |t|
      t.string :value
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
