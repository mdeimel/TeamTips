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
  end
  
  # Getter and setter for virtual attribute "body"
  def body
    @body ||= self.content.split(@@title_separator,2).last unless self.content.nil?
  end
  
  def body=(val)
    self.content = [title, val].join(@@title_separator)
  end
  
  def self.search params, user
    if (!params[:search].nil? && !params[:search].empty?) || (!params[:user].nil? && !params[:user].empty?)
      query, conditions = create_conditions params
      start_time = Time.now
      tips = Tip.find(:all, :conditions => [query.join(' AND ')] + conditions)
      finish_time = Time.now
      search_time = finish_time - start_time
      SavedSearch.create!(:search=>"#{params[:search]}---#{params[:user]}", :seconds=>search_time, :user=>user, :ip=>params[:ip])
    end
    [tips||=Array.new, search_time||= nil]
  end

  private
  @@title_separator = "\r\ntitle\r\n"
  def validate_content
    if (content =~ /.+#{@@title_separator}.+/).nil?
      self.errors.add_to_base "Title and body must both be set"
      return false
    end
  end
  
  def self.create_conditions params
    #Tip.find(:all, :conditions => 
    # ["content like ? AND content like ?"] + ["%database%", "%step%"])
    query = Array.new
    conditions = Array.new
    if !params[:user].nil? && !params[:user].empty?
      query.push "user like ?"
      conditions.push params[:user]
    end
    if !params[:search].nil? && !params[:search].empty?
      # Split all search criteria on spaces, and search in content
      params[:search].split(' ').each do |keyword|
        query.push "content like ?"
        conditions.push "%#{keyword}%"
      end
    end
    [query, conditions]
  end
end
