class AddCompanyToEmployees < ActiveRecord::Migration
  def change
    add_reference :employees, :company, index: true, null: false
  end
end
