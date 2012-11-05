class window.App.Views.Posts extends Backbone.View
  id:"posts"
  template: ''
  events:
    "click #save-new-post": "addPost"

  initialize: ->
    @.setElement($("#posts"))
    _.bindAll @, "render", "addPost"
    @collection.bind "reset", @render
    @collection.bind "remove", @render
    @vent = _.extend({}, Backbone.Events)
    @

  render: ->
    $posts = $(".posts")
    $posts.html("")
    vent = @vent
    @collection.each (post) ->
      view = new window.App.Views.PostView
        model: post
        vent: vent
      $posts.append view.render().el
      view.build()
    @

  addPost: (e) ->
    #add post
    e.stopImmediatePropagation()
    post = new App.Models.Post $('#new-post-form').serializeObject()
    post.save()
    @collection.add post, {at: 0}
    $('#new-post-form input').val('')
    @collection.fetch()


class window.App.Views.PostView extends Backbone.View
  tagName: "div"
  className: "post"
  template: "#post-template"
  events:
    "click .addComment": "saveNewComment"
    "click .remove-post": "removePost"
    "click .upvote": "upvoteComment"
    "click .downvote": "downvoteComment"

  initialize: ->
    _.bindAll @, "render", "removePost", "build", "rebuild", "upvoteComment", "downvoteComment"
    @collection = @model.comments
    @collection.bind "reset", @rebuild
    @collection.bind "add", @rebuild
    @collection.bind "remove", @rebuild

  rebuild: ->
    @render()
    @build()

  build: ->
    $comments = @$(".comments")
    $comments.html("")
    post = @model
    @model.get('comments').each (comment) ->
      view = new window.App.Views.CommentView
        model: comment
        post: post
      $comments.append view.render().el
      view.build()
      # view.setEvents()
    @

  downvoteComment: (e) ->
    e.stopImmediatePropagation()
    if window.User.id in @model.get('vote_ids')
      @model.get('vote_ids').pop(window.User.id)
      @model.save
        votes: @model.get('votes')-1
        voter_ids: @model.get('vote_ids')
      @render()

  upvoteComment: (e) ->
    console.log @model.get('voter_ids'), @model
    e.stopImmediatePropagation()
    if window.User.id in @model.get('vote_ids')
      return
    else
      @model.get('vote_ids').push(window.User.id)
      @model.save
        votes: @model.get('votes')+1
        voter_ids: @model.get('vote_ids')
      @render()

  saveNewComment: (e) ->
    e.stopImmediatePropagation()
    data = @$("#new-comment-form-"+@model.id).serializeObject()
    comment = new window.App.Models.Comment(data)
    comments = @model.get('comments')
    @collection.add comment
    comment.save
      parent_id: @model.id
      type: "post"
      user_id: window.User.id
      email: window.User.get('email')
    @$("input").val('')

    
  removePost: (e) ->
    e.stopImmediatePropagation()
    @model.destroy()
    @remove()

  render: ->
    $(@el).html(Mustache.render($(@template).html(),@model.toJSON()))
    if window.User.id == @model.get("user_id")
      @$(".remove-post").show()
      if @model.get('vote_ids')? and window.User.id in @model.get('vote_ids')
        @$(".downvote").show()
        @$(".upvote").hide()
      else
        @$(".downvote").hide()
        @$(".upvote").show()
    if window.User.id?
      @$(".comment-buttons").show()
      @$(".form-horizontal").show()
    @

class window.App.Views.CommentView extends Backbone.View
  tagName: "div"
  className: "comment"
  template: "#comment-template"
  events:
    "click .addComment": "saveNewComment"
    "click .remove-comment": "removeComment"
    "click .upvote": "upvoteComment"
    "click .downvote": "downvoteComment"


  initialize: ->
    @post = @options.post
    _.bindAll @, "render", "removeComment", "saveNewComment", "rebuild", "upvoteComment", "downvoteComment"
    @collection = @model.comments
    @collection.bind "reset", @rebuild
    # @collection.bind "change", @change
    @collection.bind "add", @rebuild
    @collection.bind "remove", @rebuild

  rebuild: ->
    @render()
    @build()

  change: ->
    comments = @model.comments
    @model.set
      comments_attributes: comments
    console.log @post.comments_attributes, @post.get('comments')
    @post.save
      comments_attributes: @post.get('comments')

  removeComment: (e) ->
    e.stopImmediatePropagation()
    collection = @model.collection
    @model.destroy()
    @remove()
  
  build: ->
    $comments = @$(".comments")
    $comments.html ""
    post = @post
    @model.comments.each (comment) ->
      view = new window.App.Views.CommentView
        model: comment
        post: post
      $comments.append view.render().el
      view.build()
    @

  downvoteComment: (e) ->
    e.stopImmediatePropagation()
    if window.User.id in @model.get('vote_ids')
      @model.get('vote_ids').pop(window.User.id)
      @model.save
        votes: @model.get('votes')-1
        voter_ids: @model.get('vote_ids')
      @render()

  upvoteComment: (e) ->
    console.log @model.get('voter_ids'), @model
    e.stopImmediatePropagation()
    if window.User.id in @model.get('vote_ids')
      return
    else
      @model.get('vote_ids').push(window.User.id)
      @model.save
        votes: @model.get('votes')+1
        voter_ids: @model.get('vote_ids')
      @render()

  saveNewComment: (e) ->
    e.stopImmediatePropagation()
    data = @$("#new-comment-form-"+@model.id).serializeObject()
    comment = new window.App.Models.Comment(data)
    comments = @model.comments
    comments.add comment
    comment.save
      parent_id: @model.id
      type: "comment"
      user_id: window.User.id
      email: window.User.get('email')
    @$("input").val('')

  render: ->
    $(@el).html(Mustache.render($(@template).html(),@model.toJSON()))
    if window.User.id == @model.get("user_id")
      @$(".remove-comment").show()
      if @model.get('vote_ids')? and window.User.id in @model.get('vote_ids')
        @$(".downvote").show()
        @$(".upvote").hide()
      else
        @$(".downvote").hide()
        @$(".upvote").show()
    if window.User.id?
      @$(".comment-buttons").show()
      @$(".form-horizontal").show()
    @