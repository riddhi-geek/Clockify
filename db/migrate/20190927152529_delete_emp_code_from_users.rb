class DeleteEmpCodeFromUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :employee_code
  end
end