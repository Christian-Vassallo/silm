class SetController < ApplicationController
  
  def index
    @settings = GVSetting::find(:all, :order => '`type`, `key` desc')

    params['settings'].each do |k, m|
      mi = @settings[k.to_i]
      mi.update_attributes(m)
      if !mi.save
        flash[:notice] = "Cannot save!"
        flash[:errors] = mi.errors
        return
      end

    end if amask(Account::AMASK_GM_ADMIN) && params['settings']

  end
end
