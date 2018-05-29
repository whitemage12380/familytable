# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Vue.component('dish-browser'
  props: ["initial_dishes", "family_id"]
  data: () ->
    return {
      dishes: this.initial_dishes
      edit: false
    }
  template: """
            <div id='family_dish_browser'>
              <div class='dish_top_bar'>
                <div class='left small' v-on:click="toggle_edit_pane">New Dish</div>
              </div>
              <dish-edit v-bind:new_dish="true" v-bind:family_id="family_id" v-if="edit" v-on:refresh="refresh"></dish-edit>
              <div class='dish_list'>
                <dish-entry v-for="dish in dishes" :key="dish.name" v-bind:dish="dish"></dish-entry>
              </div>
            </div>
            """
  methods:
    refresh: (event) ->
      that = this
      $.ajax(
        url: "/family_dishes"
        data:
          family_id: this.family.id
        dataType: "json"
        success: (res) ->
          that.dishes = res
          that.toggle_edit_pane()
        error: (res) ->
          alert("Boo2")
      )
    toggle_edit_pane: () ->
      this.edit = !(this.edit)
)

Vue.component('dish-entry'
  props: ["dish"]
  data: () ->
    return edit: false
  template: """
           <div>
             TEST!!!
           </div>
           """
  methods:
    toggle_edit_pane: (event) ->
      this.edit = !(this.edit)
)

Vue.component('dish-edit'
  props:
    dish:
      type: Object
      default: () ->
        return {
          name: ""
          description: ""
          is_favorite: false
          is_prepared_ahead: false
          health_level: 0
          comfort_level: 0
          cooking_difficulty: 0
          prep_time_minutes: 0
          cooking_time_minutes: 0
        }
    new_dish:
      type: Boolean
      default: () ->
        return false
    family_id:
      type: Number
  template: """
            <div>
              TESTING
            </div>
            """
)
