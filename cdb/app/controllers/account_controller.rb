require 'duration'

class AccountController < ApplicationController

  before_filter :authenticate, :only => ['logout', 'show']
  before_filter(:only => ['show']) {|c| c.authenticate(Account::SEE_ALL_CHARACTERS) }
  before_filter(:only => ['amask']) {|c| c.authenticate(Account::CAN_SEE_AUDIT_TRAILS) }

  def login
      @param = params
  
    if session[:user].nil? && params['login'] != nil
      session[:user] = Account.authenticate(params['login']['account'], params['login']['password'])
      if !session[:user]
        flash[:notice] = "Benutzername nicht gefunden, oder falsches Passowrt!"
        flash[:error] = true
      end
      redirect_to :controller => 'character', :action => 'index' if session[:user]
    end
  end

  def logout
      session[:user] = nil
  end

  def index
    redirect_to :action => "details"
  end

  def details
    @account = session[:user]
    det = params['account']
    if det != nil
      if !session[:user].update_attributes(det)
        flash[:notice] = "Konnte die Werte nicht speichern!"
        flash[:errors] = session[:user].errors
      else
        flash[:notice] = "Okay, abgespeichert!"
        redirect_to :controller => 'character', :action => 'index'
      end
    end
  end

  def show
    @u = Account.find(:first, :conditions => ["id = ?", params['id']])
  end


  def amask
    id = params[:id]
    begin
      @account = Account::find(id)
    rescue
      @account = nil
      return
    end

    new_mask = params[:mask]
  end
end
