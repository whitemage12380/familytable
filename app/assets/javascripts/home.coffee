# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Vue.component('family-sidebar'
  props: ["family"]
  template: """
            <div id='family_sidebar'>
              <div class="sidebar_heading">
                {{ family.name }}
              </div>
              <div class="family_member_sidebar_entry" v-for="family_member in family.family_members">
                <div class="profile_image_circle"></div>
                <div class="sidebar_entry_name">{{ family_member.first_name }}</div>
              </div>
              <div class="family_member_sidebar_entry">
                <div class="center">New Family Member</div>
              </div>
            </div>
            """
)
$ ->
  new Vue(
    el: "#sidebar"
  )
