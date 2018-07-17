class CreateLessionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :lession_logs do |t|
      t.boolean :pass
      t.bigint :spend_time, default: 0
      t.references :user, foreign_key: true
      t.references :lession, foreign_key: true
      t.timestamps
    end
  end
end
