class window.App.Views.OrdersView extends Backbone.View
  id:"orders"
  events:
    "click #new-order": "newOrder"

  initialize: ->
    @.setElement($("#orders"))
    _.bindAll @, "render"
    @collection.bind "reset", @render
    @collection.bind "add", @render
    @collection.bind "remove", @render
    @orders = @collection
    @

  render: ->
    $orders = $("#orders .orders")
    $orders.html("")
    @collection.each (order) =>
      view = new window.App.Views.OrderView
        model: order
        collection: order.get('items')
        parent: @
      $orders.prepend view.build().el
      view.render()
    @

  newOrder: ->
    new_order = new window.App.Models.Order
      items: new window.App.Collections.OrderItems()
    @collection.each (order) ->
      if order.get('state') == "Active"
        order.set('state','Saved')
        order.save()
    new_order.set('state','Active')
    new_order.save()
    @collection.add new_order

class window.App.Views.OrderView extends Backbone.View
  className: "order"
  template: "#orders-order-template"
  events:
    "click .makeCurrentOrder": "makeCurrentOrder"
    "click .placeOrder": "placeOrder"

  initialize: ->
    _.bindAll @, "render","build"
    @model.updateOrder()
    @parent = @options.parent
    @collection.bind "remove", @render

  build: ->
    $(@el).html(Mustache.render($(@template).html(),@model.toJSON()))
    @

  render: ->
    @model.updateOrder()
    $items = $("."+@model.id)
    $items.html("")
    @collection.each (item) ->
      view = new window.App.Views.OrderItemView
        model: item
      $items.append view.render().el
    if @model.get("state") == "Saved"
      @$(".makeCurrentOrder").show()
    if @model.get("state") == "Active"
      @$(".placeOrder").show()
    if @model.get("state") == "Ordered"
      @$(".state").show()
      @$(".removeFromOrder").attr("disabled", "disabled")
    @

  placeOrder: ->
    @model.set('state','Ordered')
    @model.save()
    @collection.each (item) ->
      item.set("state","Ordered")
      item.save()
    window.App.currentOrder = null
    location.reload()

  makeCurrentOrder: ->
    @model.collection.each (order) ->
      if order.get('state') == "Active"
        order.set('state','Saved')
        order.save()
    @model.set('state','Active')
    @model.save()
    window.App.currentOrder = @model.id
    location.reload()

class window.App.Views.OrderItemView extends Backbone.View
  tagName: "tr"
  className: "item"
  template: "#order-item-template"
  events:
    "click .removeFromOrder": "removeFromOrder"

  initialize: ->
    _.bindAll @, "render","removeFromOrder"

  removeFromOrder: ->
    @model.set({state:'Stocked', order_id:null})
    @model.save()
    @model.collection.remove(@model)

  render: ->
    $(@el).html(Mustache.render($(@template).html(),@model.toJSON()))
    @