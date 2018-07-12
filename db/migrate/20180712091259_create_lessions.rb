class CreateLessions < ActiveRecord::Migration[5.2]
  def change
    create_table :lessions do |t|
      t.string :name
      t.string :description
      t.string :image
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
