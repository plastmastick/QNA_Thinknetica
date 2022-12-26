class CreateAuthorisations < ActiveRecord::Migration[6.1]
  def change
    create_table :authorisations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :authorisations, [:provider, :uid]
  end
end
