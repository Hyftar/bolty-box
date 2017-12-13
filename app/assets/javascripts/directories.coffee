# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".directory-index-line").hover(
    (e) ->
      $(e.currentTarget).children(".fa-folder").toggleClass('fa-folder fa-folder-open')
    ,
    (e) ->
      $(e.currentTarget).children(".fa-folder-open").toggleClass('fa-folder-open fa-folder')
    )
