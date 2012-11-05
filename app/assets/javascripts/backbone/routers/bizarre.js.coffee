class window.App.Routers.Bizarre extends Backbone.Router
  routes:
    '': 'home'

  initialize: ->
    #shopview needs shop and items
    window.User = new window.App.Models.User()
    window.User.fetch()
    @posts = new window.App.Collections.Posts()
    @posts.fetch()
    @postsView = new window.App.Views.Posts
      collection: @posts
    console.log @posts
    @postsView.render()

  home: ->
    # @showOrders()

  # updateCurrentOrder: =>
  #   if @orders.where({state:"Active"}).length
  #     window.App.currentOrder = @orders.where({state:"Active"})[0].id

  # hideAll: ->
  #   $("#orders").hide()
  #   $("#buy").hide()
  #   $("#sell").hide()

  # showSell: ->
  #   @hideAll()
  #   @inventory.fetch()
  #   @shopView.render()
  #   $("#sell").show()

  # showBuy: ->
  #   @hideAll()
  #   @itemlist.fetch()
  #   @buyview.render()
  #   $("#buy").show()

  # showOrders: ->
  #   @hideAll()
  #   @orders.fetch()
  #   $("#orders").show()

# App.Controllers.Documents = Backbone.Controller.extend(
#   routes:
#     "documents/:id": "edit"
#     "": "index"
#     'new': "newDoc"

#   edit: (id) ->
#     doc = new Document(id: id)
#     doc.fetch
#       success: (model, resp) ->
#         new App.Views.Edit(model: doc)

#       error: ->
#         new Error(message: "Could not find that document.")
#         window.location.hash = "#"


#   index: ->
#     $.getJSON "/documents", (data) ->
#       if data
#         documents = _(data).map((i) ->
#           new Document(i)
#         )
#         new App.Views.Index(documents: documents)
#       else
#         new Error(message: "Error loading documents.")


#   newDoc: ->
#     new App.Views.Edit(model: new Document())
# )