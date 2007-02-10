# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'const'

class ApplicationController < ActionController::Base
	layout "main"

	after_filter :set_charset

	def set_charset
		charset = "iso-8859-15"
		content_type = @headers["Content-Type"] || "text/html"
		if /^text\//.match(content_type)
			@headers["Content-Type"] = "#{content_type}; charset=#{charset}" 
		end
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

        protected
        def authenticate
                unless session[:user]
                        session[:redirect_to] = request.request_uri
                        flash[:notice] = "Du musst dich einloggen um auf diese Seite zuzugreifen."
                        redirect_to :controller => "account", :action => "login"
                        return false
                end
        end
        def authenticate_char_admin
                unless session[:user] && session[:user].char_admin? 
                        session[:redirect_to] = request.request_uri
                        flash[:notice] = "Du musst Administrator sein, um diese Aktion auszufuehren."
                        redirect_to :controller => "account", :action => "index"
                        return false
                end
        end
        def authenticate_mod_admin
                unless session[:user] && session[:user].mod_admin?
                        session[:redirect_to] = request.request_uri
                        flash[:notice] = "Du musst Administrator sein, um diese Aktion auszufuehren."
                        redirect_to :controller => "account", :action => "index"
                        return false
                end
        end
        def authenticate_audit_admin
                unless session[:user] && session[:user].audit_admin?
                        session[:redirect_to] = request.request_uri
                        flash[:notice] = "Du musst Administrator sein, um diese Aktion auszufuehren."
                        redirect_to :controller => "account", :action => "index"
                        return false
                end
        end
        def authenticate_craft_admin
                unless session[:user] && session[:user].craft_admin?
                        session[:redirect_to] = request.request_uri
                        flash[:notice] = "Du musst Administrator sein, um diese Aktion auszufuehren."
                        redirect_to :controller => "account", :action => "index"
                        return false
                end
        end
        
	def authenticate_object_admin
                unless session[:user] && session[:user].object_admin?
                        session[:redirect_to] = request.request_uri
                        flash[:notice] = "Du musst Object-Admin sein, um diese Aktion auszufuehren."
                        redirect_to :controller => "account", :action => "index"
                        return false
                end
        end

	def authenticate_char_view
                unless session[:user] && session[:user].char_view?
                        session[:redirect_to] = request.request_uri
                        flash[:notice] = "Du musst Administrator sein, um diese Aktion auszufuehren."
                        redirect_to :controller => "account", :action => "index"
                        return false
                end
        end
        def authenticate_mod_view
                unless session[:user] && session[:user].mod_view?
                        session[:redirect_to] = request.request_uri
                        flash[:notice] = "Du musst Administrator sein, um diese Aktion auszufuehren."
                        redirect_to :controller => "account", :action => "index"
                        return false
                end
        end
        def authenticate_audit_view
                unless session[:user] && session[:user].audit_view?
                        session[:redirect_to] = request.request_uri
                        flash[:notice] = "Du musst Administrator sein, um diese Aktion auszufuehren."
                        redirect_to :controller => "account", :action => "index"
                        return false
                end
        end
        def authenticate_craft_view
                unless session[:user] && session[:user].craft_view?
                        session[:redirect_to] = request.request_uri
                        flash[:notice] = "Du musst Administrator sein, um diese Aktion auszufuehren."
                        redirect_to :controller => "account", :action => "index"
                        return false
                end
        end


	def enter_details
		unless session[:user] && session[:user].details?
                        session[:redirect_to] = request.request_uri
			flash[:notice] = "Bitte trage deine persoenlichen Details ein, bevor du deine Anmeldung bearbeitest."
			redirect_to :controller => "account", :action => "details"
			return false	
		end
	end

        def gobackfilter
                session[:last_url2] = session[:last_url] #request.request_uri
                session[:last_url] = request.request_uri
                true
        end
	
end
