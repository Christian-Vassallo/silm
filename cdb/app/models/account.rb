class Account < ActiveRecord::Base
	AMASK = {
#'AMASK_ANY' => 0x0,
'AMASK_RESTRICTED' => 0x1,
#'AMASK_REGISTERED' => 0x2,
'AMASK_MENTOR' => 0x4,
'AMASK_MENTOR_ADMIN' => 0x8,
'AMASK_GM' => 0x10,
'AMASK_GM_ADMIN' => 0x20,
'AMASK_FORCETALK' => 0x40,
'AMASK_FORCETALK_OBJECT' => 0x80,
'AMASK_CHAR' => 0x100,
'AMASK_CHAR_ADMIN' => 0x200,
'AMASK_CRAFT' => 0x1000,
'AMASK_CRAFT_ADMIN' => 0x2000,
'AMASK_AUDIT' => 0x10000,
'AMASK_AUDIT_ADMIN' => 0x20000,
'AMASK_BACKEND' => 0x100000,
'AMASK_BACKEND_ADMIN' => 0x200000,
	}

	has_many :characters, :foreign_key => "account"
#	has_many :comments, :foreign_key => "id"
	
	attr_accessible :playername, :sex, :email, :playerage, :roleplay_experience

	def self.authenticate(user, clear_pass)
		find(:first, :conditions => [ "account = ? and password = SHA1(?)", user, clear_pass])
	end

	def validate
		errors.add(:email, "ist ungueltig") unless email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
		errors.add(:playerage, "ist ungueltig") unless playerage.to_i > 0 && playerage.to_i < 200
		errors.add(:roleplay_experience, "ist zu lang") if roleplay_experience.size > 10000
	end

	def char_admin?
		char_admin == "true" 
	end
	def char_view?
		char_view == 'true' || char_admin?
	end
	def mod_admin?
		mod_admin == 'true' 
	end
	def mod_view?
		mod_view == 'true' || mod_admin?
	end
	def audit_admin?
		audit_admin == 'true' 
	end
	def object_admin?
		object_admin == 'true' 
	end

	def audit_view?
		audit_view == 'true' || audit_admin?
	end
	def craft_admin?
		craft_admin == 'true' 
	end
	def craft_view?
		craft_view == 'true' || craft_admin?
	end

	def details?
		email != "" && playerage != "" && roleplay_experience != "" && playername != "" && sex != "n"
	end

	def dm?
		dm == 'true'
	end
	
	def other_chars(session, char = nil)
		if char != nil && session[:user] && session[:user].char_view?
			return Character.find(:all, :conditions => ['`create_key` = ? or `account` = ?', char.create_key, char.account.id])
		end
		return characters
	end


	def total_time
		tt = 0
		all = Character.find(:all, :conditions => ['account = ?', self.id])
		all.each {|n| tt += n.total_time }
		return tt
	end

	def amask_a
		r = []
		AMASK.sort{|a,b| a[1] <=> b[1]}.each {|k,v|
			r << k if self.amask & v == v
		}
		r
	end
end
