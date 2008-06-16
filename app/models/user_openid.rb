class UserOpenid < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :openid_url
  validates_uniqueness_of :openid_url

  def denormalized_url                                                      
    self.openid_url.gsub(%r{^https?://}, '').gsub(%r{/$},'')                
  end    
end
