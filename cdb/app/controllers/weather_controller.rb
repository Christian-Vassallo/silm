class WeatherController < ApplicationController
  before_filter { authenticate(Account::SEE_ALL_CHARACTERS) }

  def index
    @overrides = WeatherOverride.find(:all, :order => "atype desc, ayear asc, amonth asc, aday asc")
  end

  def del
    WeatherOverride.delete(params['id'])
    redirect_to :action => 'index'
  end

  def add
    o = {'aid' => session[:user]['id'] }
    %w{atype ayear amonth aday zyear zmonth zday temp wind prec}.each do |i|
      o[i] = params[i]
    end
    o['wind'] = WeatherOverride.type_to_val(WeatherOverride::WIND_TYPES, o['wind'])
    o['temp'] = WeatherOverride.type_to_val(WeatherOverride::TEMP_TYPES, o['temp'])
    o['prec'] = WeatherOverride.type_to_val(WeatherOverride::PREC_TYPES, o['prec'])
    
    %w{wind prec temp ayear amonth aday zyear zmonth zday}.each do |i|
      o[i] = o[i].to_i
    end

    w = WeatherOverride.new(o)
    if !w.save
      flash[:error] = "Cannot save."
      flash[:errors] = w.errors
    else
      flash[:notice] = "Added."
    end
    redirect_to :action => "index", :controller => "weather"
  end
end
