
class User < ActiveRecord::Base
	set_table_name "user"
	set_primary_key "user_id"

  cattr_accessor :current_user
  
  def before_create
    self.password = encrypt(self.password) #if self.plain_password
  end

  def self.getToken()
    User.find(:last, :conditions => ["COALESCE(token, '') != ''"]) rescue nil
  end

  def self.authenticate(login, password)
    u = find :first, :conditions => {:username => login}
    auth = u && u.authenticated?(password) ? u : nil

    unless auth.nil?
      auth.update_attribute("token", User.random_string(20))
    end
    #raise password
  end

  def self.logout
    u = User.find(:last, :conditions => ["COALESCE(token, '') != ''"]) rescue nil
    u.update_attribute("token", nil) if !u.nil?
  end

  def authenticated?(plain)
    #  raise "#{plain} #{password} #{encrypt(plain, salt)} #{salt} :  #{Digest::SHA1.hexdigest(plain+salt)} : #{self.salt}"
    #raise "#{self.salt}"
    encrypt(plain) == password || Digest::SHA1.hexdigest("#{plain}") == password
  end

  # Encrypts plain data with the salt.
  # Digest::SHA1.hexdigest("#{plain}#{salt}") would be equivalent to
  # MySQL SHA1 method, however OpenMRS uses a custom hex encoding which drops
  # Leading zeroes
  def encrypt(plain)
    encoding = ""
    digest = Digest::SHA1.digest("#{plain}")
    (0..digest.size-1).each{|i| encoding << digest[i].to_s(16) }
    encoding
  end

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end


end