#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new window.App.Routers.Bizarre()
    Backbone.history.start()

$(document).ready ->
  window.App.init()
  vent = _.extend({}, Backbone.Events)