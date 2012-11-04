class Comment
  include Mongoid::Document

  field :votes,      :type => Integer, :default => 0
  field :voted, :type => Array
  field :content,    :type => String

  belongs_to :user
  embedded_in :comment_comments, polymorphic: true
  embedded_in :post_comments, polymorphic: true
  embeds_many :comments, as: :comment_comments, cascade_callbacks: true
  accepts_nested_attributes_for :comments, allow_destroy: true
  # attr_accessible :comments_attributes

end