class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :avatar
      t.string :provider
      t.string :uid
      t.string :domain
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.string :password_digest
      t.string :remember_digest
      t.boolean :admin
      t.string :activation_digest, default: false
      t.boolean :activated
      t.datetime :activated_at
      t.datetime :reset_sent_at
      t.string :reset_digest

      t.timestamps
    end
  end
end
