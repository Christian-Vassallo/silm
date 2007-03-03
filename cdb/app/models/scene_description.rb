class SceneDescription < ActiveRecord::Base
  def locked?
    self.locked == 'true'
  end
end
