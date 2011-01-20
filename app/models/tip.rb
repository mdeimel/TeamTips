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

  private
  @@title_separator = "\r\ntitle\r\n"
  def validate_content
    if (content =~ /.+#{@@title_separator}.+/).nil?
      self.errors.add_to_base "Title and body must both be set"
      return false
    end
  end
end
