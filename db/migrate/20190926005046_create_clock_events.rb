class CreateClockEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :clock_events do |t|
      t.datetime :clock_in
      t.datetime :clock_out
      t.integer  :shift_id

      t.timestamps
    end
    add_index :clock_events, :shift_id
  end
end
