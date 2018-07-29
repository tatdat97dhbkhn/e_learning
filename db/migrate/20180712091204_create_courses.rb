class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :image
      t.references :category, foreign_key: true
      t.boolean :used, default: true
      
      t.timestamps
    end
  end
end
