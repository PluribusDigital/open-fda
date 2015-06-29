module ApplicationHelper
  def unescape_periods(param)
      # url encoding doesn't work well w/ periods
      # rails router thinks it is a file type designator
      escaped_period = "-*-"
      return param.gsub(escaped_period,".")
    end  
end
