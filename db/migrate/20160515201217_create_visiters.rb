class CreateVisiters < ActiveRecord::Migration
  def change
    create_table :visiters do |t|
      t.string :ip
      t.integer :total_questions, default: 0

      t.timestamps null: false
    end
  end
end
