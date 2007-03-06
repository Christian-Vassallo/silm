class ChatlogController < ApplicationController
  before_filter {|c| c.authenticate(Account::CAN_SEE_AUDIT_TRAILS) }

  def index
    if params['goto']
      # parse date!
      # session['cl_goto'] = @goto
    end
    @goto = session['cl_goto'] || Time.now
    
    search = (params['chatlog_search'] || "").strip
    @csearch = search
    search = search.split(" ").reject{|x| x.strip == ""}.compact
    #cond = "!(mode & 0) or ( "
    cond = "!(mode & 8) and ( "
    conda = []
    if search.size > 0
      search.each {|s|
          s = '%' + s + '%'
          cond += " "
          cond += " ("
          cond += " character_s like ? "
          cond += " or account_s like ? "
          cond += " or area like ? "
          cond += " ) or "
          conda << [s] * 3
      }
    end
    cond += " 1=1 )"
    order = "timestamp asc"
    perpage = 100
  
    if search.size > 0
      @log_pages, @logs = paginate :chatlogs, :order => order, :per_page => perpage, :conditions => [cond, conda].flatten
    else
      @log_pages, @logs = paginate :chatlogs, :order => order, :per_page => perpage, :conditions => [cond, conda].flatten
    end
    
    goto_index = Chatlog::find(:first, :conditions => ['timestamp >= from_unixtime(?)', @goto.to_i])
    if goto_index.nil?
      goto_index = Chatlog::find(:first, :order => 'timestamp desc')
    end

    # all items
    goto_count = Chatlog::count(:conditions => [cond,conda].flatten)
    if goto_index != nil
      cp = 5
      @log_pages.current_page = cp
      #render :text => "goto_count => #{goto_count}, perpage => #{perpage}, goto_index = #{goto_index.inspect}"
    end
  end

end
