class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # Do not allow @ in usernames to avoid conflicts with email addresses
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  attr_accessor :login

  # Associations
  has_many :family_members
  accepts_nested_attributes_for :family_members

  # Check username and email for login, use whichever fits
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  def save_with_related_objects(params)
    family = nil
    save_family = false

    case params[:family_option]
    when "new_family"
      family = Family.new(params[:family])
      save_family = true
    when "existing_family"
      raise "Functionality to create family member to existing family is not currently implemented."
    when "existing_family_member"
      raise "Functionality to associate user with existing family member is not currently implemented."
    else
      raise "Invalid family option #{params[:family_option]}."
    end

    family_member = FamilyMember.new(params[:family_member])
    family_member.birth_date = Date.strptime(params[:family_member][:birth_date], '%m/%d/%Y')
    
    transaction do
      save
      if save_family
        family.save
      end
      family_member.family_id = family.id
      family_member.user_id = id
      family_member.save
    end
  end
end
