class window.App.Views.Posts extends Backbone.View
  id:"posts"
  template: ''
  events:
    "click #save-new-post": "addPost"

  initialize: ->
    @.setElement($("#posts"))
    _.bindAll @, "render", "addPost"
    @collection.bind "reset", @render
    @collection.bind "add", @render
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

  addPost: ->
    #add item
    post = new App.Models.Post $('#new-post-form').serializeObject()
    post.save()
    @collection.add post, {at: 0}
    $('#newPostModal').modal('hide')


class window.App.Views.PostView extends Backbone.View
  tagName: "div"
  className: "post"
  template: "#post-template"
  events:
    "click .addComment": "saveNewComment"
    "click .remove-post": "removePost"

  initialize: ->
    _.bindAll @, "render", "removePost", "build", "rebuild"
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

  saveNewComment: (e) ->
    e.stopImmediatePropagation()
    data = @$("#new-comment-form-"+@model.id).serializeObject()
    comment = new window.App.Models.Comment(data)
    comments = @model.get('comments')
    comments.add comment
    console.log comments
    @model.save
      comments_attributes: comments
    @$("input").val('')
    
  removePost: (e) ->
    e.stopImmediatePropagation()
    @model.destroy()
    @remove()

  render: ->
    $(@el).html(Mustache.render($(@template).html(),@model.toJSON()))
    @

class window.App.Views.CommentView extends Backbone.View
  tagName: "div"
  className: "comment"
  template: "#comment-template"
  events:
    "click .addComment": "saveNewComment"
    "click .remove-comment": "removeComment"

  initialize: ->
    @post = @options.post
    _.bindAll @, "render", "removeComment", "saveNewComment", "rebuild"
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
    @model.set
      _destroy: "1"
    @post.save
      comments_attributes: @post.get('comments')
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

  saveNewComment: (e) ->
    e.stopImmediatePropagation()
    data = @$("#new-comment-form-"+@model.id).serializeObject()
    comment = new window.App.Models.Comment(data)
    comments = @model.comments
    comments.add comment
    console.log comments
    @model.set
      comments_attributes: comments
    @post.save
      comments_attributes: @post.comments
    @$("input").val('')

  render: ->
    $(@el).html(Mustache.render($(@template).html(),@model.toJSON()))
    @