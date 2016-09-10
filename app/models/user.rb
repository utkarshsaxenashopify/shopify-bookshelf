require 'digest/md5'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  before_destroy :delete_activities

  validates :name, presence: true, on: :create
  has_many :books
  has_many :books_readings, dependent: :destroy
  has_many :books_reads, dependent: :destroy
  has_many :books_wishlists, dependent: :destroy
  has_many :stories, dependent: :destroy
  before_save { self.gravitarhash = Digest::MD5.hexdigest(self.email)}

  def delete_activities
    activities = PublicActivity::Activity.where(owner_id: self.id, owner_type: "User")
    activities.delete_all
  end
end
