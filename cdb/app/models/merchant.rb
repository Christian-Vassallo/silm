class Merchant < ActiveRecord::Base
	has_many :merchant_inventory, :foreign_key => 'merchant'

end
