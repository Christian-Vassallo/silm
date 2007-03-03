class Character < ActiveRecord::Base
  #helper :application

  has_many :comments, :foreign_key => "character", :order => "date asc"
  


  def validate
    errors.add("This character is locked and cannot be modifies!") if
      locked?
  end


  MIN_PER_HR = 15

  #before_save :savefilter

# StatusFields = %w{new register accept reject ban} #Character.columns_hash['status']
  
  StatusFields = Character.columns_hash['status'].sql_type.gsub(/^enum\('/, "").gsub(/'\)$/, "").split("','")

# belongs_to :account, :foreign_key => :id
  attr_accessible :status, :appearance, :traits, :biography, :register_on

  def account
    Account.find(:first, :conditions => ["id = ?", self['account']])
  end

  # Returns true if this luser is online
  def online?
    current_time > 0
  end

  def locked?
    locked == 'yes'
  end

  def login_for
    online? ? Time.now.to_i - current_time : 0
  end
  
  #def read_attribute(stuff)
  # dat = super(stuff)
  # if dat.is_a? String
  #   dat.gsub("~", "'")
  # else
  #   dat
  # end
  #end
  
  #def savefilter
  # %w{character}.each do |c|
  #   self[c].gsub!("'", "~")
  # end
  # true
  #end

  def dm?
    dm == 'true'
  end

  def dm
    account.dm
  end

  def alignment(long = false)
    (case alignment_ethical
      when 1
        long ? "Neutral" : "N"
      when 2
        long ? "Rechtschaffen" : "R"
      when 3
        long ? "Chaotisch" : "C"
      else
        "?"
    end + (long ? " " : "") + case alignment_moral
      when 1
        long ? "Neutral" : "N"
      when 4
        long ? "Gut" : "G"
      when 5
        long ? "Boese" : "B"

      else
        "?"
    end)
  end
  

  # Returns the PROPER age
  def age
    org_age = super()
    # character exists for secdiff seconds REALTIME
    secdiff = (Time.now.to_i - create_on.to_i).to_f
    
    # one hour ingame time is 17 minutes realtime
    
    # character exists for mindiff hours RLT
    mindiff = secdiff / 60

    # This transports to hr_ig hours INGAME
    hr_ig = mindiff / MIN_PER_HR
    
    # there are 24 hours on a day
    day_ig = hr_ig / 24

    # and 360 days a year
    yr_ig = day_ig / 360

    # +1 because of a time jump in ig time!
    1 + org_age + yr_ig
  end


  def craft_skills
    CraftingSkill.find(:all, :conditions => ['`character` = ? and (skill_theory > 0 or skill_practical > 0)', self.id])
  end
  
  # Returns all product stats that were produced with this skill
  def craft_stats
    CraftingStatistic.find(:all, :conditions => ['`character` = ? and recipe > 0 and (fail > 0 or count > 0)', self.id])
  end
  
  # Returns how much xp this cid collected
  def xp_time
    f = TimeXP.find_by_sql('select sum(xp) as xp from time_xp where cid = %d' % [self.id])
    if f && f[0]
      f[0].xp
    else
      0
    end
  end

  def last_audited_logins n = 100
    Audit::find(:all, :limit => n.abs, 
      :order => 'date desc',
      :conditions => ["category = 'module' and (event = 'login' or event = 'logout') and `player` = ? and `char` = ?", self.account.account, self.character]
    )
  end

  def lph
    messages.to_f / (total_time / 3600)
  end

end
