class Tip < ActiveRecord::Base
  validates_presence_of :content, :user
  attr_protected :pageloads, :content
  before_create :validate_content
  
  # Getter and setter for virtual attribute "title"
  def title
    @title ||= self.content.split(@@title_separator).first unless self.content.nil?
  end
  
  def title=(val)
    self.content = [val, body].join(@@title_separator)
    @title = val # Reset class value so it's not stale
  end
  
  # Getter and setter for virtual attribute "body"
  def body
    @body ||= self.content.split(@@title_separator,2).last unless self.content.nil?
  end
  
  def body=(val)
    self.content = [title, val].join(@@title_separator)
    @body = val # Reset class value so it's not stale
  end
  
  def self.search search_str, search_user, session_user, ip
    if (!search_str.nil? && !search_str.empty?) || (!search_user.nil? && !search_user.empty?)
      query, conditions, split = create_conditions search_str, search_user
      start_time = Time.now
      tips = Tip.find(:all, :conditions => [query.join(' AND ')] + conditions, :order => 'pageloads DESC,updated_at DESC')
      finish_time = Time.now
      search_time = (finish_time - start_time).to_f
      SavedSearch.create!(:search=>"#{search_str}---#{search_user}", :seconds=>search_time, :user=>session_user, :ip=>ip)
    end
    [tips||=Array.new, search_time||= nil, split||=Array.new]
  end
  
  def self.get_stats
    user_tip_count = Hash.new
    users = Tip.find(:all, :select => "distinct user")
    users.each do |user|
      user_tip_count[user.user] = Tip.count(:all, :conditions => ["user like ?", user.user])
    end
    user_tip_count
  end

  private
  @@title_separator = "\r\ntitle\r\n"
  def validate_content
    if (content =~ /.+#{@@title_separator}.+/).nil?
      self.errors.add_to_base "Title and body must both be set"
      return false
    end
  end
  
  def self.create_conditions search_str, search_user
    #Tip.find(:all, :conditions => 
    # ["content like ? AND content like ?"] + ["%database%", "%step%"])
    query = Array.new
    conditions = Array.new
    if !search_user.nil? && !search_user.empty?
      query.push "user like ?"
      conditions.push search_user
    end
    if !search_str.nil? && !search_str.empty?
      # Split search criteria and search in content
      split = split_search(search_str)
      split.each do |keyword|
        query.push "content like ?"
        conditions.push "%#{keyword}%"
      end
    end
    [query, conditions, split]
  end
  
  def self.split_search search_str
    split = Array.new
    # First separate quoted strings
    regex = Regexp.new(/".*?"/)
    quoted_strings = search_str.scan(regex)
    quoted_strings.each do |str|
      split.push(str.gsub("\"","")) # Push the string to the array, and remove quotes
    end
    search_str_no_quotes = search_str.gsub(regex, "") # Remove quoted strings from search
    # Last, split on spaces
    search_vals = search_str_no_quotes.split(' ')
    search_vals.each do |str|
      split.push(str)
    end
    split
  end
end
