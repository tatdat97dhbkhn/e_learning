class CreateQuestionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :question_logs do |t|
      t.references :lesson_log, foreign_key: true
      t.references :question, foreign_key: true
      t.integer :number
      t.integer :answer_id

      t.timestamps
    end
  end
end
