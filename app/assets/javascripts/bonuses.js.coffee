# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $(".bonus_value").live "click", (e) ->
    toggle_field e, this, "bonus_id"

  $("img[action=apply]").live "click", (e) ->
    apply_toggled_field e, this, "bonus_id", "/bonuses/update_value/"

  $("[action=no-action]").live "click", ->
    alert "You cannot change the bonus value after it's been claimed or paid"