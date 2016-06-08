class AddLastActiveToVisiters < ActiveRecord::Migration
  def change
    add_column :visiters, :last_active, :datetime
  end
end
