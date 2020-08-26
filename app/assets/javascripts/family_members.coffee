# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Vue.component('family-member-entry'
  props: ["family_member"]
  data: () ->
    return edit: false
  template: """
            <div class="family_member_sidebar_entry">
              <div v-on:click="toggle_edit_pane">
                <family-member-circle v-bind:first_name="family_member.first_name" />
                <div class="sidebar_entry_name">{{ family_member.first_name }}</div>
              </div>
            <family-member-edit v-bind:family_member="family_member" v-if="edit"></family-member-edit>
            </div>
            """
  methods:
    toggle_edit_pane: (event) ->
      this.edit = !(this.edit)
)

Vue.component('family-member-edit'
  props:
    family_member:
      type: Object
      default: () ->
        return {first_name: "", last_name: ""}
    new_family_member:
      type: Boolean
      default: () ->
        return false
    family_id:
      type: Number
  template: """
            <div class="right_pop_pane">
              <input v-model="family_member.first_name" placeholder="First name" />
              <input v-model="family_member.last_name" placeholder="Last name" />
              <date-picker v-model="family_member.birth_date" v-once></date-picker>
              <button v-on:click="save">Save</button>
            </div>
            """
  methods:
    save: (event) ->
      if this.new_family_member
        save_url = '/family_members'
        save_method = 'POST'
        this.family_member.family_id = this.family_id
      else
        save_url = "/family_members/#{this.family_member.id}"
        save_method = 'PATCH'
      that = this
      $.ajax(
        url: save_url
        method: save_method
        data:
          family_member: this.family_member
        dataType: "json"
        success: (res) ->
          that.$emit('refresh')
        error: (res) ->
          alert("Boo")
      )
)

Vue.component('family-member-picker'
  props:
    family_members:
      type: Array
      default: () ->
        return []
  template: """
            <div class="family_member_picker">
              <family-member-circle v-for="family_member in this.family_members" :key="family_member.id"
                                    v-on:click="select(family_member)"
                                    v-bind:first_name="family_member.first_name"
              />
              <div class="clear"></div>
            </div>
            """
  methods:
    select: (family_member) ->
      this.$emit('input', family_member)
)

Vue.component('family-member-circle'
  props: ['first_name']
  template: """
            <div class="profile_image_circle" v-bind:title="first_name" v-on:click="click">
              {{this.first_letter()}}
            </div>
            """
  methods:
    first_letter: () ->
      this.first_name[0]
    click: () ->
      this.$emit('click')
)
