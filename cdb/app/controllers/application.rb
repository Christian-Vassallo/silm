# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'const'

class ApplicationController < ActionController::Base
	layout "main"

	after_filter :set_charset

	def set_charset
		charset = "iso-8859-15"
		content_type = headers["Content-Type"] || "text/html"
		if /^text\//.match(content_type)
			headers["Content-Type"] = "#{content_type}; charset=#{charset}" 
		end
	end
	
	
	# returns the currently logged in user
	def get_user
		return nil if !session[:uid] || session[:uid] < 1
		Account::find(session[:uid])
	end
	
	def amask(mask)
		logger.warn("amask(n) is deprecated")
		amask?(mask)
	end
	
	def amask?(mask)
		return false if !get_user
		return get_user.amask & mask > 0 
	end

	def goback
		if session[:redirect_to]
			redirect_to_url(session[:redirect_to]) if session[:redirect_to] != request.request_uri
		elsif session[:last_url2]
			redirect_to_url(session[:last_url2]) if session[:last_url2] != request.request_uri
		else session[:last_url]
			redirect_to_url(session[:last_url]) if session[:last_url] != request.request_uri
		end
	end

			
	def authenticate mask = 0
		if !get_user
			session[:redirect_to] = request.request_uri
			flash[:notice] = "Du musst dich einloggen um auf diese Seite zuzugreifen."
			redirect_to :controller => "account", :action => "login"
			return false
		end

		unless enter_details
			return false
		end
		
		
		#flash[:notice] = self.method('amask').call(mask)
		#redirect_to :controller => "account", :action => "details"
		#return false

		if mask > 0 && !amask?(mask)
			flash[:notice] = "Du hast nicht die noetigen Rechte, um diese Seite zu sehen."	
			redirect_to :controller => "account", :action => "details"
			return false
		end
	end


	protected

	def enter_details
		unless get_user && get_user.details?
			session[:redirect_to] = request.request_uri
			flash[:notice] = "Bitte trage deine persoenlichen Details ein, bevor du deine Anmeldung bearbeitest."
			redirect_to :controller => "account", :action => "details"
			return false	
		end
		return true
	end

	def gobackfilter
		session[:last_url2] = session[:last_url] #request.request_uri
		session[:last_url] = request.request_uri
		true
	end

end
