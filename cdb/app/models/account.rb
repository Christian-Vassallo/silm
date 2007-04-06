class Account < ActiveRecord::Base
	AMASK = {
		'AMASK_ANY' , 0,
		'AMASK_SEE_ALL_CHARACTERS' , 1,
		'AMASK_CAN_SEE_ALL_CHARACTERS' , 1,
		'AMASK_IS_CHARACTER_ADMIN' , 2,
		'AMASK_CAN_USE_MACROS' , 4,
		'AMASK_SEE_ALL_MENTORS' , 8,
		'AMASK_CAN_SEE_ALL_MENTORS' , 8,
		'AMASK_IS_GM' , 16,
		'AMASK_GM' , 16,
		'AMASK_IS_GLOBAL_GM' , 32,
		'AMASK_GLOBAL_GM' , 32,
		'AMASK_FORCETALK' , 64,
		'AMASK_GLOBAL_FORCETALK' , 128,
		'AMASK_CAN_SET_PERSISTENCY' , 256,
		'AMASK_CAN_CHANGE_WEATHER' , 512,
		'AMASK_CAN_SEE_CRAFTING' , 1024,
		'AMASK_CAN_EDIT_CRAFTING' , 2048,
		'AMASK_CAN_SEE_MERCHANTS' , 4096,
		'AMASK_CAN_EDIT_MERCHANTS' , 8192,
		'AMASK_CAN_SEE_CHATLOGS' , 16384,
		'AMASK_CAN_SEE_PRIVATE_CHATLOGS' , 32768,
		'AMASK_CAN_SEE_AUDIT_TRAILS' , 65536,
		'AMASK_CAN_RESTART_SERVER' , 131072,
		'AMASK_CAN_SEE_GV' , 262144,
		'AMASK_CAN_EDIT_GV' , 524288,
		'AMASK_CAN_SEE_ACCOUNT_DETAILS', 1048576,
		'AMASK_CAN_SEE_RIDEABLES', 2097152,
		'AMASK_CAN_EDIT_RIDEABLES', 4194304,
		'AMASK_CAN_SEE_LOOT_CHAINS', 8388608,
		'AMASK_CAN_EDIT_LOOT_CHAINS', 16777216,
		'AMASK_CAN_DO_BACKEND' , 8589934592,
	}
	AMASK.each {|k,v|
		Account::const_set(k.gsub(/^AMASK_/, ""), v)
		Account::const_set(k, v)
	}

	has_many :characters, :foreign_key => "account"
# has_many :comments, :foreign_key => "id"
	
	attr_accessible :playername, :sex, :email, :playerage, :roleplay_experience

	def self.authenticate(user, clear_pass)
		find(:first, :conditions => [ "account = ? and password = SHA1(?)", user, clear_pass])
	end

	def validate
		errors.add(:email, "ist ungueltig") unless email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
		errors.add(:playerage, "ist ungueltig") unless playerage.to_i > 0 && playerage.to_i < 200
		errors.add(:roleplay_experience, "ist zu lang") if roleplay_experience.size > 10000
	end

	def details?
		# email != "" && playerage != "" && roleplay_experience != "" && playername != "" && sex != "n"
		true
	end

	def other_chars(session, char = nil)
		if char != nil && amask & Account::SEE_ALL_CHARACTERS > 0
			return Character.find(:all, :conditions => ['`create_key` = ? or `account` = ?', char.create_key, char.account.id])
		end
		return characters
	end

	def amask?(mask)
		super.amask & mask > 0
	end

	def total_time
		tt = 0
		all = Character.find(:all, :conditions => ['account = ?', self.id])
		all.each {|n| tt += n.total_time }
		return tt
	end
	
	#returns an [] with all KEYs this user has
	def amask_a
		r = []
		vv = []
		AMASK.sort{|a,b| a[1] <=> b[1]}.each {|k,v|
			if !vv.index(v) && amask & v > 0
				vv << v
				r << k
			end 
		}
		r
	end
	
	
	#returns an [] with all KEYs sorted by value
	def self.amask_a
		r = []
		vv = []
		AMASK.sort{|a,b| a[1] <=> b[1]}.each {|k,v|
			if !vv.index(v)
				vv << v
				r << k
			end 
		}
		r
	end
end

