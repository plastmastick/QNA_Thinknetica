class AddConfirmableDeviseToUsers < ActiveRecord::Migration[6.1]
  def change
    ## Confirmable
    # default devise migration 20221009144434_devise_create_users
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
  end
end
