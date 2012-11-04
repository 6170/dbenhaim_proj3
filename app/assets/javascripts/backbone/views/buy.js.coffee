class window.App.Views.buyView extends Backbone.View
  id:"buy"
  template: ''

  initialize: ->
    @.setElement($("#buy"))
    _.bindAll @, "render"
    @collection.bind "reset", @render
    @collection.bind "add", @render
    @collection.bind "remove", @render
    @itemlist = @collection
    @

  render: ->
    collection = @collection
    $table = $(".itemlist")
    $table.html("")
    @collection.each (item) ->
      view = new window.App.Views.BuyItemView
        model: item
      $table.append view.render().el
    @


class window.App.Views.BuyItemView extends Backbone.View
  tagName: "tr"
  className: "item"
  template: "#buyer-item-template"
  events:
    "click .addToCart": "addToCart"

  initialize: ->
    _.bindAll @, "render","addToCart"

  addToCart: ->
    if window.App.currentOrder
      @model.set({state:'In Cart', order_id: window.App.currentOrder})
      @model.save()
      @model.collection.remove(@model)
    else
      alert "Please Start an Order or set one to 'Active'"

  render: ->
    $(@el).html(Mustache.render($(@template).html(),@model.toJSON()))
    @