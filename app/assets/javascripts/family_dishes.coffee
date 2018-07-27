# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Vue.component('dish-browser'
  props: ["initial_dishes", "family_id"]
  data: () ->
    return {
      dishes: this.initial_dishes
      edit: false
      selected_dish: null
      selected_dish_mode: "detail"
    }
  template: """
            <div id='family_dish_browser'>
              <div class='dish_top_bar'>
                <div class='left small button' v-on:click="toggle_edit_pane">New Dish</div>
                <dish-edit v-bind:new_dish="true" v-bind:family_id="family_id" v-if="edit" v-on:refresh="refresh"></dish-edit>
              </div>
              <div class="clear"></div>
              <div class="list_section">
                <div class='dish_list'>
                  <dish-entry v-for="dish in dishes" :key="dish.id" v-bind:dish="dish" v-on:select="set_dish_detail"></dish-entry>
                </div>
              </div>
              <div class="detail_section">
                <dish-detail v-if="selected_dish != null" v-bind:dish="selected_dish"></dish-detail>
                <div v-else class="align-center">
                  Select a dish to view details.
                </div>
              </div>
            </div>
            """
  methods:
    refresh: (event) ->
      that = this
      $.ajax(
        url: "/family_dishes"
        data:
          family_id: this.family_id
        dataType: "json"
        success: (res) ->
          that.dishes = res
          that.toggle_edit_pane()
        error: (res) ->
          alert("Boo2")
      )
    toggle_edit_pane: () ->
      this.edit = !(this.edit)
    set_dish_detail: (dish_id) ->
      select_dish = (x) -> x.id == dish_id
      this.selected_dish = this.dishes.filter(select_dish)[0]
      this.selected_dish_mode = "detail"
)

Vue.component('dish-entry'
  props: ["dish"]
  data: () ->
    return edit: false
  template: """
           <div class="dish_entry_space">
             <div class="dish_entry">
               <div class="dish_entry_main" v-on:click="$emit('select', dish.id)">
                 <div class="dish_entry_name">{{ dish.name }}</div>
                 <div class="dish_entry_levels">
                   <dot-gauge v-bind:is_input="false" v-bind:initial_value="dish.cooking_difficulty">Difficulty</dot-gauge>
                   <dot-gauge v-bind:is_input="false" v-bind:initial_value="dish.health_level">Health</dot-gauge>
                   <dot-gauge v-bind:is_input="false" v-bind:initial_value="dish.comfort_level">Comfort</dot-gauge>
                 </div>
               </div>
               <div class="dish_entry_controls">
                 <div class="dish_edit_button" v-on:click="toggle_edit_pane">Edit</div>
               </div>
               <div class="clear"></div>
             </div>
             <dish-edit v-bind:dish="dish" v-bind:family_id="dish.family_id" v-if="edit" v-on:refresh="refresh"></dish-edit>
             <div class="clear"></div>
           </div>
           """
  methods:
    toggle_edit_pane: (event) ->
      this.edit = !(this.edit)
    refresh: (event) ->
      this.edit = false
      this.$emit('refresh')
)

Vue.component('dish-detail'
  props: ["dish"]
  template: """
            <div class="detail_pane">
              <h1>{{ dish.name }}</h1>
            </div>
            """
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
            <div class="edit_pane">
              <div class="edit_column large">
                <input v-model="dish.name" placeholder="Dish Name" />
                <textarea v-model="dish.description" placeholder="Description" />
                <button v-on:click="save">Save</button>
              </div>
              <div class="edit_column med noborder">
                <dot-gauge v-bind:initial_value="dish.cooking_difficulty" v-model="dish.cooking_difficulty">Difficulty</dot-gauge>
                <dot-gauge v-bind:initial_value="dish.health_level" v-model="dish.health_level">Health</dot-gauge>
                <dot-gauge v-bind:initial_value="dish.comfort_level" v-model="dish.comfort_level">Comfort</dot-gauge>
              </div>
              <div class="clear"></div>
            </div>
            """
  methods:
    save: (event) ->
      if this.new_dish
        save_url = '/family_dishes'
        save_method = 'POST'
        this.dish.family_id = this.family_id
      else
        save_url = "/family_dishes/#{this.dish.id}"
        save_method = 'PATCH'
      that = this
      $.ajax(
        url: save_url
        method: save_method
        data:
          family_dish: this.dish
        dataType: "json"
        success: (res) ->
          that.$emit('refresh')
        error: (res) ->
          alert("Boo")
      )
)
