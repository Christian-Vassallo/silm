class AuditController < ApplicationController
	before_filter :authenticate_audit_admin

	def index
		@audit_pages, @audit = paginate :audit, :order => "id desc", :per_page => 100
	end
end
