class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  validates_presence_of :title, :content
  field :title, :type => String
  field :content, :type => String
  field :email, :type => String
  belongs_to :user
  has_many :comments
  accepts_nested_attributes_for :comments, allow_destroy: true

  def as_json(options={})
    {:title           => self.title,
     :content         => self.content,
     :comments        => self.comments,
     :user_id         => self.user_id,
     :email           => self.email,
     :_id             => self.id
   }
  end
end
