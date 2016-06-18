class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :correct_question
      t.integer :question_count
      t.string :visiter_ip

      t.timestamps null: false
    end
  end
end
