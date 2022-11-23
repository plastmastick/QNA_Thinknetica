class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :title
      t.belongs_to :question
      t.belongs_to :owner, null: true

      t.timestamps
    end
  end
end
