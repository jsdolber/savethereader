class User < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :subscription_groups, :dependent => :destroy
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def ungrouped_subscriptions
    self.subscriptions.where(:group_id => nil)
  end
end
