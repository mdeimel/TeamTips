module TipsHelper
  def highlight_body body, search_split
    results = Array.new
    search_vals = ""
    search_split.each do |split| search_vals+=split+"|" end
    search_vals.chop! # Remove extra pipe character
    counter = 0
    body.each_line do |line|
      break if counter >= 5
      line = h(line) # Escape the line before sending it back to be used with raw()
      replaced_line = line.gsub(/#{search_vals}/i) { |val| "<b>#{val}</b>" }
      if replaced_line != line
        results.push(replaced_line)
        counter+=1
      end
    end
    results
  end
end
