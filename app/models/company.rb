class Company < ActiveRecord::Base
    has_many :employees
    validates_presence_of :company_name, :company_address
    
end
