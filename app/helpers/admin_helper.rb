module AdminHelper
  def user_tip_count_bar_chart user_tip_count
    labels="" # Include tip count in this label
    user_tip_count.keys.each_with_index { |k, i| labels<<"|"<<k<<" ("<<user_tip_count.values[i].to_s<<")"}
    width = (user_tip_count.size * 50) + 150 # Ensure chart is wide enough for all users
    return "<img src=\"http://chart.apis.google.com/chart?chxl=1:#{labels}&chxr=0,0,#{user_tip_count.values.max}&chxt=y,x&chbh=a&chs=#{width}x150&cht=bvs&chds=0,#{user_tip_count.values.max}&chd=t:#{user_tip_count.values.join ","}&chtt=Number+of+Tips\" alt=\"\" />"
  end
  
  def user_tip_count_pie_chart user_tip_count
    return "<img src=\"http://chart.apis.google.com/chart?chs=300x150&cht=p3&chds=0,#{user_tip_count.values.sum}&chd=t:#{user_tip_count.values.join ","}&chp=0.1&chl=#{user_tip_count.keys.join "|"}&chtt=Percentage+of+Total+Tips\" alt=\"\" />"
  end
end
