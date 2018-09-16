# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

time_methods = {
  methods:
    minutes_to_natural: (min) ->
      return null if min == null or min == 0
      hour_string="hours"
      min_string="minutes"
      hours = Math.floor(min / 60)
      min_left = min % 60
      hour_string = hour_string.replace(/s$/, "") if hours == 1
      min_string  = min_string.replace(/s$/, "")  if min_left == 1
      if hours > 0
        output = "#{hours} #{hour_string}"
        if min_left > 0
          output += " #{min_left} #{min_string}"
      else
        output = "#{min} #{min_string}"
      return output
    natural_to_minutes: (text) ->
      return null if text == null or text == ""
      minutes_strings = ["m", "min", "minute", "minutes"]
      hours_strings = ["h", "hr", "hrs", "hour", "hours"]
      hours = 0
      min = 0
      tokens = text.split(" ")
      i = 0
      while i < tokens.length
        token = tokens[i]
        last_token = tokens.length <= i+1
        if not /^(0|[1-9]\d*)$/.test(token) # Is the token not an integer?
          i++
          continue
        if last_token
          if min == 0
            min = Number(token)
            break
          else
            return null # Minutes set twice, might want to raise an error here
        else
          next_token = tokens[i+1]
          if hours_strings.includes(next_token) and hours == 0
            hours = Number(token)
          else if minutes_strings.includes(next_token) and min == 0
            min = Number(token)
          else
            return null # Parsing problem or hours or minutes set twice, might want to raise an error here
          i += 2
      min += (hours * 60)
      return min

}

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
                <div class='left small button' v-on:click="set_dish_new">New Dish</div>
              </div>
              <div class="clear"></div>
              <div class="list_section">
                <div class='dish_list'>
                  <dish-entry v-for="dish in dishes" :key="dish.id" v-bind:dish="dish" v-on:select="set_dish_detail" v-on:edit="set_dish_edit"></dish-entry>
                </div>
              </div>
              <div class="detail_section">
                <dish-detail    v-if="selected_dish != null && selected_dish_mode == 'detail'" v-bind:dish="selected_dish"
                                                                                               v-on:edit="set_dish_edit">
                                                                                               </dish-detail>
                <dish-edit v-else-if="selected_dish != null && selected_dish_mode == 'edit'"   v-bind:dish="selected_dish" 
                                                                                               v-bind:family_id="family_id"
                                                                                               v-on:refresh="refresh"
                                                                                               v-on:cancel="set_dish_detail">
                                                                                               </dish-edit>
                <dish-edit v-else-if="selected_dish_mode == 'new'"                             v-bind:new_dish="true"
                                                                                               v-bind:family_id="family_id"
                                                                                               v-on:refresh="refresh"
                                                                                               v-on:cancel="unset_dish_pane">
                                                                                               </dish-edit>
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
          if that.selected_dish_mode == "edit"
            that.selected_dish_mode = "detail"
          else
            that.unset_dish_pane()
        error: (res) ->
          alert("Boo2")
      )
    set_dish_pane: (dish_id, mode) ->
      select_dish = (x) -> x.id == dish_id
      this.selected_dish = this.dishes.filter(select_dish)[0]
      this.selected_dish_mode = mode
    unset_dish_pane: () ->
      this.selected_dish = null
      this.selected_dish_mode = null
    set_dish_detail: (dish_id) ->
      this.set_dish_pane(dish_id, "detail")
    set_dish_edit: (dish_id) ->
      this.set_dish_pane(dish_id, "edit")
    set_dish_new: () ->
      this.selected_dish = null
      this.selected_dish_mode = "new"
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
                 <div class="dish_edit_button" v-on:click="$emit('edit', dish.id)">Edit</div>
               </div>
               <div class="clear"></div>
             </div>
             <dish-edit v-bind:dish="dish" v-bind:family_id="dish.family_id" v-if="edit" v-on:refresh="refresh"></dish-edit>
             <div class="clear"></div>
           </div>
           """
  methods:
    refresh: (event) ->
      this.edit = false
      this.$emit('refresh')
)

Vue.component('dish-detail'
  mixins: [time_methods]
  props: ["dish"]
  template: """
            <div class="detail_pane">
              <div class="pane_control" v-on:click="$emit('edit', dish.id)">E</div>
              <div class="pane_column large">
                <h2>{{ dish.name }}</h2>
                <p>{{ dish.description }}</p>
              </div>
              <div class="pane_column med noborder">
                <dot-gauge v-if="dish.cooking_difficulty > 0" v-bind:is_input="false" v-bind:initial_value="dish.cooking_difficulty">Difficulty</dot-gauge>
                <dot-gauge v-if="dish.health_level > 0"       v-bind:is_input="false" v-bind:initial_value="dish.health_level">Health</dot-gauge>
                <dot-gauge v-if="dish.comfort_level > 0"      v-bind:is_input="false" v-bind:initial_value="dish.comfort_level">Comfort</dot-gauge>
                <div class="clear"></div>
                <div v-if="dish.prep_time_minutes > 0">
                  <h5>Prep Time</h5>
                  <p>{{ minutes_to_natural(dish.prep_time_minutes) }}</p>
                </div>
              </div>
              <div class="clear"></div>
            </div>
            """
)

Vue.component('dish-edit'
  mixins: [time_methods]
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
              <div class="pane_control" v-on:click="$emit('cancel', dish.id)">B</div>
              <div class="pane_column large">
                <input v-model="dish.name" placeholder="Dish Name" />
                <textarea v-model="dish.description" placeholder="Description" class="form_description" />
                <button v-on:click="save">Save</button>
              </div>
              <div class="pane_column med noborder">
                <dot-gauge v-bind:initial_value="dish.cooking_difficulty" v-model="dish.cooking_difficulty">Difficulty</dot-gauge>
                <dot-gauge v-bind:initial_value="dish.health_level" v-model="dish.health_level">Health</dot-gauge>
                <dot-gauge v-bind:initial_value="dish.comfort_level" v-model="dish.comfort_level">Comfort</dot-gauge>
                <div class="clear"></div>
                <h5>Prep Time</h5>
                <input v-once v-bind:value="minutes_to_natural(dish.prep_time_minutes)" v-on:input="dish.prep_time_minutes = natural_to_minutes($event.target.value)" />
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
