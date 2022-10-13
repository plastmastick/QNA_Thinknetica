class AddAuthorToQuestionsAndAnswers < ActiveRecord::Migration[6.1]
  def change
    change_table :questions do |t|
      t.references :author, foreign_key: { to_table: :users }
    end

    change_table :answers do |t|
      t.references :author, foreign_key: { to_table: :users }
    end
  end
end
