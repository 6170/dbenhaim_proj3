# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  # Setup drop down menu
  $(".dropdown-toggle").dropdown()
  # Fix input element click problem
  $(".dropdown input, .dropdown label").click (e) ->
    e.stopPropagation()
_.templateSettings =
    interpolate: /\{\{\=(.+?)\}\}/g
    evaluate: /\{\{(.+?)\}\}/g

$.fn.serializeObject = ->
  o = {}
  a = @serializeArray()
  $.each a, ->
    if o[@name] isnt `undefined`
      o[@name] = [o[@name]]  unless o[@name].push
      o[@name].push @value or ""
    else
      o[@name] = @value or ""
  o