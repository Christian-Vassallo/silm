class AuditController < ApplicationController
  before_filter { authenticate(Account::CAN_SEE_AUDIT_TRAILS) }


  def index
    @audit_pages, @audit = paginate :audit, :order => "id desc", :per_page => 100
  end
end
