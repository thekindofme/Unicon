class User < ActiveRecord::Base
  # ALL of the following code is for OpenID integration. If you are not using OpenID in your app
  # just remove all of the following code, to the point where you User class is completely blank.
  #acts_as_authentic :login_field_validation_options => {:if => :openid_identifier_blank?}, :password_field_validation_options => {:if => :openid_identifier_blank?}
  acts_as_authentic
#  acts_as_authentic do |c|
#    #c.my_value = my_option
#    c.login_field_validation_options = {:if => :openid_identifier_blank?}
#    c.password_field_validation_options = {:if => :openid_identifier_blank?}
#  end
#  validate :normalize_openid_identifier
#  validates_uniqueness_of :openid_identifier, :allow_blank => true
#  validates_length_of :email, :minimum => 500, :unless => "true"
#
#  # For acts_as_authentic configuration
#  def openid_identifier_blank?
#    openid_identifier.blank?
#  end
#
#  def deliver_password_reset_instructions!
#    reset_perishable_token!
#    Notifier.deliver_password_reset_instructions(self)
#  end
  
  #########################
  #user roles reladed code#
  #########################
  has_many :user_roles
  has_many :roles, :through => :user_roles
 
  def has_role?(role)
    self.roles.count(:conditions => ["name = ?", role]) > 0
  end

  def add_role(role)
    return if self.has_role?(role)
    self.roles << Role.find_by_name(role)
  end
  #########################
  #user roles reladed code#
  #########################

  #is this user a admin?
  def is_admin?
    return has_role? "admin"
  end
  
  private
    def normalize_openid_identifier
      begin
        self.openid_identifier = OpenIdAuthentication.normalize_url(openid_identifier) if !openid_identifier.blank?
      rescue OpenIdAuthentication::InvalidOpenId => e
        errors.add(:openid_identifier, e.message)
      end
    end
end
