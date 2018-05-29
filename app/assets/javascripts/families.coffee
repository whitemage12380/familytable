# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Vue.component('family-sidebar'
  props: ["initial_family"]
  data: () ->
    return {
      family: this.initial_family
      edit: false
    }
  template: """
            <div id='family_sidebar'>
              <div class="sidebar_heading">
                {{ family.name }}
              </div>
              <family-member-entry v-for="family_member in family.family_members" :key="family_member.id" v-bind:family_member="family_member"></family-member-entry>
              <div class="family_member_sidebar_entry">
                <div v-on:click="toggle_edit_pane">
                  <div class="center">New Family Member</div>
                </div>
                <family-member-edit v-bind:new_family_member="true" v-bind:family_id="family.id" v-if="edit" v-on:refresh="refresh"></family-member-edit>
              </div>
            </div>
            """
  methods:
    refresh: (event) ->
      that = this
      $.ajax(
        url: "/families/#{this.family.id}"
        dataType: "json"
        success: (res) ->
          that.family = res
          that.toggle_edit_pane()
        error: (res) ->
          alert("Boo2")
      )
    toggle_edit_pane: () ->
      this.edit = !(this.edit)
)
