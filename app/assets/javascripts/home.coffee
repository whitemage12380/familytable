# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Vue.component('family-sidebar'
  props: ["family"]
  data: () ->
    return edit: false
  template: """
            <div id='family_sidebar'>
              <div class="sidebar_heading">
                {{ family.name }}
              </div>
              <family-member-entry v-for="family_member in family.family_members" :key="family_member.id" v-bind:family_member="family_member"></family-member-entry>
              <div class="family_member_sidebar_entry">
                <div v-on:click="open_edit_pane">
                  <div class="center">New Family Member</div>
                </div>
                <family-member-edit v-if="edit"></family-member-edit>
              </div>
            </div>
            """
  methods:
    open_edit_pane: (event) ->
      this.edit = !(this.edit)
)

Vue.component('family-member-entry'
  props: ["family_member"]
  data: () ->
    return edit: false
  template: """
            <div class="family_member_sidebar_entry">
              <div v-on:click="open_edit_pane">
                <div class="profile_image_circle"></div>
                <div class="sidebar_entry_name">{{ family_member.first_name }}</div>
              </div>
            <family-member-edit v-bind:family_member="family_member" v-if="edit"></family-member-edit>
            </div>
            """
  methods:
    open_edit_pane: (event) ->
      this.edit = !(this.edit)
)

Vue.component('family-member-edit'
  props:
    family_member:
      type: Object
      default: () ->
        return {first_name: "", last_name: ""}
  template: """
            <div class="right_pop_pane">
              <input v-model="family_member.first_name" placeholder="First name" />
              <input v-model="family_member.last_name" placeholder="Last name" />
            </div>
            """
)
            

$ ->
  new Vue(
    el: "#sidebar"
  )
