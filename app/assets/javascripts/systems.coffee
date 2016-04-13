# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "page:change", ->
  $("table.clickableRows").on "click", "tr", (e) ->
    targetTag = e.target.tagName.toLowerCase()
    if targetTag != 'td' && targetTag != 'tr'
      return;
    e.preventDefault()
    window.location = $(this).find("a").attr("href");
