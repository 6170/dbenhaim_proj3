Backbone.Model::nestCollection = (attributeName, nestedCollection) ->
  #setup nested references
  for item, i in nestedCollection
    @attributes[attributeName][i] = nestedCollection.at(i).attributes

  #create empty arrays if none
  nestedCollection.bind 'add', (initiative) =>
    if !@get(attributeName)
      @attributes[attributeName] = []
    @get(attributeName).push(initiative.attributes)

  nestedCollection.bind 'remove', (initiative) =>
    updateObj = {}
    updateObj[attributeName] = _.without(@get(attributeName), initiative.attributes)
    @set(updateObj)

  nestedCollection

class window.App.Models.Comment extends Backbone.Model
  idAttribute: "_id"
  initialize: (resp) ->
    @comments = @nestCollection('comments', new App.Collections.Comments(resp.comments))
    @bind 'change', =>
      @comments = @nestCollection('comments', new App.Collections.Comments(@get('comments')))
    @

class window.App.Collections.Comments extends Backbone.Collection
  model: window.App.Models.Comment

class window.App.Models.Post extends Backbone.Model
  urlRoot: '/posts'
  idAttribute: "_id"
  parse: (resp, xhr) ->
    resp.comments = new window.App.Collections.Comments(resp.comments)
    resp
  initialize: ->
    @comments = @nestCollection('comments', new App.Collections.Comments(@get('comments')))
    @bind 'change', =>
      @comments = @nestCollection('comments', new App.Collections.Comments(@get('comments')))

class window.App.Collections.Posts extends Backbone.Collection
  url: '/posts'
  model: window.App.Models.Post
  