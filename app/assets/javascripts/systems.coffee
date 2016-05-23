# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "page:change", ->
  makeRowClickable()

  $("table.availableUpdates").on "click", ".checkboxInstallUpdate", (e) ->
    disableCreateJobButton()

  disableCreateJobButton()

# make the whole row clickable. trigger location change by getting the link from the details-button
clickOnWholeRow = (e) ->
  if $(e.target).parents("ul.button-bar").length > 0 || $(e.target).is("input")
    return;
  e.preventDefault()
  trgt = $(e.target).parents("tr").find("ul.button-bar li.first a").attr("href")
  if trgt != undefined
    window.location = trgt

disableCreateJobButton = ->
  enabled = $(".checkboxInstallUpdate:checked").length > 0
  if enabled
    $("#createJobBtn").removeAttr('disabled')
  else
    $("#createJobBtn").attr('disabled', 'disabled')

makeRowClickable = ->
  $("table.clickableRows").on "click", "tbody tr", (e) ->
    clickOnWholeRow(e)
