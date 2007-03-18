require 'duration'

class AccountController < ApplicationController

  before_filter :authenticate, :only => ['logout', 'show']
  before_filter(:only => ['show', 'amask']) {|c| c.authenticate(Account::CAN_SEE_ACCOUNT_DETAILS) }

  def login
      @param = params
  
	if get_user.nil? && params['login'] != nil
    		accobj = Account.authenticate(params['login']['account'], params['login']['password'])
		if accobj.nil?
			flash[:notice] = "Benutzername nicht gefunden, oder falsches Passowrt!"
			flash[:error] = true
		else
        		session[:uid] = accobj['id']
		        redirect_to :controller => 'character', :action => 'index'
		end
	end
  end

  def logout
      session[:uid] = nil
  end

  def index
    redirect_to :action => "details"
  end

  def details
    @account = get_user
    det = params['account']
    if det != nil
      if !get_user.update_attributes(det)
        flash[:notice] = "Konnte die Werte nicht speichern!"
        flash[:errors] = get_user.errors
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
	if new_mask && amask?(Account::CAN_DO_BACKEND)

      mask = 0

      new_mask = new_mask.to_a.reject {|x| x[0] !~ /^AMASK_/ }.each {|k,v|
        mask |= Account::AMASK[k] if Account::AMASK[k]
      }
      @account.update_attribute('amask', mask)
      
      if !@account.save
        flash[:errors] = @account.errors
        flash[:notice] = "cannot save new amask?"
      else
        flash[:notice] = "new mask = #{mask}, saved"
      end
    end

    @pusers = Account::find(:all, :conditions => 'amask > 0', :order => 'amask desc')
  end
end
