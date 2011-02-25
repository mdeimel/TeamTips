module AdminHelper
  def user_tip_count_bar_chart user_tip_count
    return "<img src=\"http://chart.apis.google.com/chart?chxl=1:|#{user_tip_count.keys.join "|"}&chxr=0,0,#{user_tip_count.values.max}&chxt=y,x&chbh=a&chs=300x150&cht=bvs&chds=0,#{user_tip_count.values.max}&chd=t:#{user_tip_count.values.join ","}&chdl=Number+of+Tips\" width=\"300\" height=\"150\" alt=\"\" />"
  end
  
  def user_tip_count_pie_chart user_tip_count
    return "<img src=\"http://chart.apis.google.com/chart?chs=300x150&cht=p3&chds=0,#{user_tip_count.values.sum}&chd=t:#{user_tip_count.values.join ","}&chp=0.1&chl=#{user_tip_count.keys.join "|"}&chtt=Percentage+of+Total+Tips\" width=\"300\" height=\"150\" alt=\"\" />"
  end
end
