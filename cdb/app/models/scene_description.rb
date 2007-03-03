class SceneDescription < ActiveRecord::Base
  attr_protected :locked

  def locked?
    self.locked == 'true'
  end
  
  
  def self.content_columns
    lockmetoo = %w{locked}

    super.reject {|x|
      lockmetoo.index(x.name) != nil
    }.flatten
  end
end
