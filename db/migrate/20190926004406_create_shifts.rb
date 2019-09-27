class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.date :shift_date
      t.string :title
      t.integer  :user_id

      t.timestamps
    end
    add_index :shifts, :user_id
  end
end
