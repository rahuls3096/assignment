class Employee < ActiveRecord::Base
    belongs_to :company

    validates_presence_of :name, :gender, :email, :age, :contact_no
  
end
