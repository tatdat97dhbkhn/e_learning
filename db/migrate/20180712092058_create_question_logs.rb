class CreateQuestionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :question_logs do |t|
      t.references :lession_log, foreign_key: true
      t.references :question, foreign_key: true
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
