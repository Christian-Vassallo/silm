class GVSetting < ActiveRecord::Base
  set_table_name 'gv'

  GVSetting.inheritance_column = "i_type"

  attr_accessible :value

  def validate
    case self['type']
    when 'int'
      errors.add("Must be integer") if value !~ /^-?\d+$/
    when 'string'
    when 'float'
    else
      errors.add "Unknown type"
    end
  end
end
