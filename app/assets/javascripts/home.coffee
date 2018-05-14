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
    family:
      name: "Neuhengen"
      family_members: [
        { first_name: 'Egan' }
        { first_name: 'Morgan' }
        { first_name: 'Diane' }
        { first_name: 'Alex' }
      ]
  mounted: () ->
    that = this
    $.ajax(
      url: '/families/12.json'
      success: (res) ->
        that.family = res
    )
)
