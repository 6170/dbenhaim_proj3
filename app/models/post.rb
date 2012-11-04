class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  validates_presence_of :title, :content
  field :title, :type => String
  field :content, :type => String
  belongs_to :user
  embeds_many :comments, as: :post_comments, cascade_callbacks: true
  accepts_nested_attributes_for :comments, allow_destroy: true
end
