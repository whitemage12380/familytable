# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

test = new Vue(
  el: '#test'
  data:
    message: 'This is a test'
)

v_family_sidebar = new Vue(
  el: '#family_sidebar'
  data:
    family_members: [
      { name: 'Egan' }
      { name: 'Morgan' }
      { name: 'Diane' }
      { name: 'Alex' }
    ]
  ready: () ->
    that = this
    $.ajax(
      url: ''
      success: (res) ->
        that.family_members = res
    )
)
