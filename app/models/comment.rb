# class Comment
#   include Mongoid::Document

#   field :votes,      :type => Integer, :default => 0
#   field :voted, :type => Array
#   field :content,    :type => String

#   belongs_to :user
#   embedded_in :comment_comments, polymorphic: true
#   embedded_in :post_comments, polymorphic: true
#   embeds_many :comments, as: :comment_comments, cascade_callbacks: true
#   accepts_nested_attributes_for :comments, allow_destroy: true
#   # attr_accessible :comments_attributes

# end

class Comment
  include Mongoid::Document

  require 'digest/md5'
  field :votes, :type => Integer, :default => 0
  field :vote_ids, :type => Array, :default => []

  # validates_presence_of   :threaded_comment_polymorphic_id, :threaded_comment_polymorphic_type, :parent_id 
  validates_length_of     :content, :within => 1..2000
  validates_length_of     :email, :minimum => 6
  validates_format_of     :email, :with => /.*@.*\./

  belongs_to :user
  belongs_to :post

  has_many :comments, :autosave => true
  belongs_to :comment

  
  # before_validation   :assign_owner_info_to_nested_comment
  
  # # attr_accessible :name, :content, :email, :user_id,  :parent_id, :threaded_comment_polymorphic_id, :threaded_comment_polymorphic_type
  
  # def assign_owner_info_to_nested_comment
  #   unless( self[:parent_id].nil? || self[:parent_id] == 0 )
  #     parentComment = Comment.find(self[:parent_id])
  #     self[:threaded_comment_polymorphic_id] = parentComment.threaded_comment_polymorphic_id
  #     self[:threaded_comment_polymorphic_type] = parentComment.threaded_comment_polymorphic_type
  #   end
  #   self[:parent_id] = 0 if( self[:parent_id].nil? )
  # end
  def as_json(options={})
    {
     :content         => self.content,
     :comments        => self.comments,
     :user_id         => self.user_id,
     :post_id         => self.post_id,
     :email           => self.email,
     :_id             => self.id,
     :votes           => self.votes,
     :vote_ids        => self.vote_ids
   }
  end
end