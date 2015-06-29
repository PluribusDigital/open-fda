module ApplicationHelper
  def unescape_trailing_period(param)
      # url encoding doesn't work well w/ a trailing period
      # rails router thinks it is a file type designator
      escaped_period = "-*-"
      if param.class == String && param[-3..-1] == escaped_period
        param = param[0..-4] + "."
      end
      return param
    end  
end
