class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :meaning
      t.string :content
      t.references :category, foreign_key: true
      t.boolean :used, default: true

      t.timestamps
    end
  end
end
