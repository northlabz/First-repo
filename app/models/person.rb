class Person < ActiveRecord::Base
  
  # the name is mandatory
  validates_presence_of :name
  
  # you can provide multiple validations, they'll be applied in turn
  
  # secret is also mandatory, but let's alter the default Rails message to be
  # more friendly
  validates_presence_of :secret,
    :message => "must be provided so we can recognize you in the future"
  
  # ensure secret has enough letters, but not too many
  validates_length_of :secret, :in => 6..24
  
  # ensure secret contains at least one number
  validates_format_of :secret, :with => /[0-9]/,
    :message => "must contain at least one number"
  
  # ensure secret contains at least one upper case  
  validates_format_of :secret, :with => /[A-Z]/,
    :message => "must contain at least one upper case character"

  # ensure secret contains at least one lower case  
  validates_format_of :secret, :with => /[a-z]/,
    :message => "must contain at least one lower case character"

  # the country field is a controlled vocabulary: we must check its
  # value is within our allowed options
  validates_inclusion_of :country, :in => ['Canada', 'Mexico', 'UK', 'USA'],
    :message => "must be one of Canada, Mexico, UK or USA"
  
  # email should read like an email address. this check isn't exhaustive,
  # but it's a good start.
  validates_format_of :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "doesn't look like a proper email address"

  # how do we recognize the same person coming back? by their email address
  # so we want to ensure the same person only signs in once
  validates_uniqueness_of :email, :case_sensitive => false,
    :message => "has already been entered, you can't sign in twice"
  
  # graduation year must be numeric, and within sensible bounds. however,
  # the person may not have graduated, so we allow a nil value too. finally
  # it must be a whole number (integer)
  validates_numericality_of :graduation_year, :allow_nil => true,
    :greater_than => 1920, :less_than_or_equal_to => Time.now.year,
    :only_integer => true
    
  # body temperature doesn't have to be a whole number, but we ought to
  # constrain possible values. we assume our users aren't in cryostasis
  validates_numericality_of :body_temperature, :allow_nil => true,
    :greater_than_or_equal_to => 60,
    :less_than_or_equal_to => 130, :only_integer => false
  
  validates_numericality_of :price, :allow_nil => true,
    :only_integer => false
    
  # restrict birthday to reasonable values, ie. not in the future and not
  # before 1900
  validates_inclusion_of :birthday,
    :in => Date.civil(1900, 1, 1) .. Date.today,
    :message => "must be between January 1st, 1900 and today"
  
  # finally, we just say that favorite time is mandatory. while the view
  # only allows you to post valid times, remember that models can be created
  # in other ways, such as from code or web service calls. so it's not safe
  # to make assumptions based on the form
  validates_presence_of :favorite_time
  
  # NEW IN THIS EXAMPLE
  
  # if person says 'can send email', then we'd like them to fill their
  # description in, so we understand who it is we're sending mail to
  validates_presence_of :description, :if => :require_description_presence?
  
  # we define the supporting condition here
  def require_description_presence?
    self.can_send_email
  end
  
  # we would also like to do some validation that Rails can't do easily.
  # if the description is present, we'd like it to be at least 5 words long,
  # and at most 50 words long
  
  # validate is called by ActiveRecord if present. we're going to set up one
  # method to validate the description, and call it from our validate method
  def validate
    validate_description
  end
  
  def validate_description
    # only do this validation if description is provided
    unless self.description.blank? then
      # simple way of calculating words: split the text on whitespace
      num_words = self.description.split.length
      if num_words < 5 then
        self.errors.add(:description, "must be at least 5 words long")
      elsif num_words > 50 then
        self.errors.add(:description, "must be at most 50 words long")
      end
    end
  end







# NEW FOR CHAPTER 8
  
  # after the person has been written to the database, deal with
  # writing any image data to the filesystem
  after_save :store_photo
  
  # File.join is a cross-platform way of joining directories,
  # we could have written "#{RAILS_ROOT}/public/photo_store"
  PHOTO_STORE = File.join RAILS_ROOT, 'public', 'photo_store'
  
  # when photo data is assigned via the upload, store the file data
  # for later and assign the file extension, e.g. ".jpg"
  def photo=(file_data)
    unless file_data.blank?
      # store the uploaded data into a private instance variable
      @file_data = file_data
      # figure out the last part of the file name and use this as
      # the file extension. e.g. from "me.jpg" will return "jpg"
      self.extension = file_data.original_filename.split('.').last.downcase
    end
  end
  
  # if a photo file exists, then we have a photo
  def has_photo?
    File.exists? photo_filename
  end
  
  # return a path we can use in HTML for the image
  def photo_path
    "/photo_store/#{id}.#{extension}"
  end
  
  # where to write the image file to
  def photo_filename
    File.join PHOTO_STORE, "#{id}.#{extension}"
  end
  
  private
  
  # called after saving, to write the uploaded image to the filesystem
  def store_photo
    if @file_data
      # make the photo_store directory if it doesn't exist already
      FileUtils.mkdir_p PHOTO_STORE
      # write out the image data to the file
      File.open(photo_filename, 'wb') do |f|
        f.write(@file_data.read)
      end
      # avoid repeat-saving
      @file_data = nil
    end
  end
end
