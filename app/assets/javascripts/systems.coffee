# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "page:change", ->
  $("table.clickableRows").on "click", "tr", (e) ->
    clickOnWholeRow(e)

  $("table.availableUpdates").on "click", ".checkboxInstallUpdate", (e) ->
    disableCreateJobButton()

  disableCreateJobButton()


clickOnWholeRow = (e) ->
  targetTag = e.target.tagName.toLowerCase()
  if targetTag != 'td' && targetTag != 'tr'
    return;
  e.preventDefault()
  window.location = $(e.target).parent().find("ul.button-bar li.first a").attr("href")

disableCreateJobButton = ->
  enabled = $(".checkboxInstallUpdate:checked").length > 0
  if enabled
    $("#createJobBtn").removeAttr('disabled')
  else
    $("#createJobBtn").attr('disabled', 'disabled')
