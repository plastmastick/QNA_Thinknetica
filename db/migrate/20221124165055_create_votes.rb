class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user, null: false, foreign_key: true
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end

    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
