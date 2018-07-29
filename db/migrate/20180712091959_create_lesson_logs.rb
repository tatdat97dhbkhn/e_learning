class CreateLessonLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :lesson_logs do |t|
      t.boolean :pass
      t.boolean :saved
      t.references :user, foreign_key: true
      t.references :lesson, foreign_key: true
      
      t.timestamps
    end
  end
end
