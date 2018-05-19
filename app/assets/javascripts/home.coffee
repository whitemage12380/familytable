# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

test = new Vue(
  el: '#test'
  data:
    message: 'This is a test'
)
$ ->
  sidebar_id = "#family_sidebar"
  sidebar_elem = $(sidebar_id)
  sidebar_family_id = sidebar_elem.data("familyid")

  console.log(sidebar_family_id)


  v_family_sidebar = new Vue(
    el: sidebar_id
    data:
      family:
        name: "Neuhengen"
        familyid: "a"
        family_members: [
          { first_name: 'Egan' }
          { first_name: 'Morgan' }
          { first_name: 'Diane' }
          { first_name: 'Alex' }
        ]
    mounted: () ->
      that = this
      $.ajax(
        url: '/families/' + sidebar_family_id + '.json'
        success: (res) ->
          that.family = res
      )
  )
