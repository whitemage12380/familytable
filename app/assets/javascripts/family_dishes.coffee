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
      #dishes: this.initial_dishes
      dishes: []
      edit: false
      selected_dish: null
      selected_dish_mode: "detail"
    }
  template: """
            <div id='family_dish_browser'>
              <div class='dish_top_bar'>
                <div class='left small button' v-on:click="set_dish_new">New Dish</div>
                <div class="clear"></div>
              </div>
              <div class='content'>
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
              <div class="clear"></div>
              </div>
            </div>
            """
  created: () ->
    this.refresh(null)
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
          console.log(that.dishes)
          if that.selected_dish_mode == "edit"
            that.selected_dish_mode = "detail"
          else
            that.unset_dish_pane()
        error: (res) ->
          alert("Failed on browser refresh")
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
              <div class="pane_content">
                <div class="pane_control" v-on:click="$emit('edit', dish.id)">E</div>

                <div class="pane_info_section">
                  <dot-gauge v-if="dish.cooking_difficulty > 0" v-bind:is_input="false" v-bind:initial_value="dish.cooking_difficulty">Difficulty</dot-gauge>
                    <dot-gauge v-if="dish.health_level > 0" v-bind:is_input="false" v-bind:initial_value="dish.health_level">Health</dot-gauge>
                    <dot-gauge v-if="dish.comfort_level > 0" v-bind:is_input="false" v-bind:initial_value="dish.comfort_level">Comfort</dot-gauge>
                    <div class="clear"></div>
                    <div v-if="dish.prep_time_minutes > 0">
                      <h5>Preparation Time</h5>
                      <p>{{ minutes_to_natural(dish.prep_time_minutes) }}</p>
                    </div>
                    <div v-if="dish.cooking_time_minutes > 0">
                      <h5>Cooking Time</h5>
                      <p>{{ minutes_to_natural(dish.cooking_time_minutes) }}</p>
                    </div>
                    <div v-if="dish.prep_time_minutes > 0 && dish.cooking_time_minutes > 0">
                      <h5>Total Time</h5>
                      <p>{{ minutes_to_natural(dish.prep_time_minutes + dish.cooking_time_minutes) }}</p>
                    </div>
                </div>
                <h2>{{ dish.name }}</h2>
                <p>{{ dish.description }}</p>
                <div v-if="dish.family_dish_ingredients.length > 0">
                  <h5>Ingredients</h5>
                  <div class="ingredient_list">
                    <div class="tag" v-for="family_dish_ingredient in dish.family_dish_ingredients" :key="family_dish_ingredient.id">{{family_dish_ingredient.ingredient.name}}</div>
                    <div class="clear"></div>
                  </div>
                </div>
                <div v-if="dish.family_member_dishes.length > 0">
                  <h5>Family Member Opinions</h5>
                  <family-member-opinion v-for="(family_member_opinion, index) in dish.family_member_dishes"
                                          :key="family_member_opinion.id"
                                          :is_input="false"
                                          v-bind:family_member_opinion="dish.family_member_dishes[index]"
                  />
                </div>
              </div>
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
          family_dish_ingredients: []
          family_member_dishes: []
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
              <div class="pane_column twothirds">
                <input v-model="dish.name" placeholder="Dish Name" />
                <textarea v-model="dish.description" placeholder="Description" class="form_description" />
                <h5>Ingredients</h5>
                <ingredient-picker v-bind:family_dish_ingredients="dish.family_dish_ingredients"></ingredient-picker>
              </div>
              <div class="pane_column third">
                <dot-gauge v-bind:initial_value="dish.cooking_difficulty" v-model="dish.cooking_difficulty">Difficulty</dot-gauge>
                <dot-gauge v-bind:initial_value="dish.health_level" v-model="dish.health_level">Health</dot-gauge>
                <dot-gauge v-bind:initial_value="dish.comfort_level" v-model="dish.comfort_level">Comfort</dot-gauge>
                <div class="clear"></div>
                <h5>Preparation Time</h5>
                <input v-once v-bind:value="minutes_to_natural(dish.prep_time_minutes)" v-on:input="dish.prep_time_minutes = natural_to_minutes($event.target.value)" />
                <h5>Cooking Time</h5>
                <input v-once v-bind:value="minutes_to_natural(dish.cooking_time_minutes)" v-on:input="dish.cooking_time_minutes = natural_to_minutes($event.target.value)" />
              </div>
              <div class="clear"></div>
              <div class="pane_column full">
              <h5>Family Member Opinions</h5>
                <family-member-dish-edit v-bind:initial_family_member_opinions="dish.family_member_dishes"
                                         v-bind:initial_family_id="family_id" 
                                         v-model:family_member_opinions="dish.family_member_dishes" />
                <button v-on:click="save">Save</button>
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
      dish_payload = JSON.parse(JSON.stringify(this.dish))
      dish_payload.family_dish_ingredients_attributes = this.dish.family_dish_ingredients.map (i) -> {ingredient_id: i.ingredient.id, id: i.id, relationship: i.relationship}
      dish_payload.family_member_dishes_attributes = this.dish.family_member_dishes.map (i) -> {
        id: i.id
        family_id: i.family_id
        family_member_id: i.family_member.id
        is_favorite: i.is_favorite
        comfort_level: i.comfort_level
        enjoyment_level: i.enjoyment_level
        cooking_ability_level: i.cooking_ability_level
        note: i.note
      }
      delete dish_payload.id
      delete dish_payload.created_at
      delete dish_payload.updated_at
      delete dish_payload.family_dish_ingredients
      delete dish_payload.family_member_dishes
      console.log("Saving dish:")
      console.log(this.dish)
      that = this
      $.ajax(
        url: save_url
        method: save_method
        data:
          family_dish: dish_payload
        dataType: "json"
        success: (res) ->
          that.$emit('refresh')
        error: (res) ->
          alert("Failed on saving dish")
      )
)

Vue.component('ingredient-picker'
  props:
    family_dish_ingredients:
      type: Array
      default: () ->
        return []
  data: () ->
    return input_text: ""
  template: """
            <div class="ingredient_picker">
              <div class="ingredient_list">
                <div class="tag" v-for="family_dish_ingredient in family_dish_ingredients" :key="family_dish_ingredient.id">{{family_dish_ingredient.ingredient.name}}</div>
              </div>
              <div class="ingredient_input">
                <input v-model="input_text" v-on:keyup.enter="add_ingredient" />
              </div>
            </div>
            """
  methods:
    add_ingredient: (event) ->
      ingredient_name = event.target.value
      ingredient = {name: ingredient_name}
      that = this
      $.ajax(
        url: '/ingredients'
        method: 'POST'
        data:
          ingredient: ingredient
        dataType: "json"
        success: (res) ->
          that.family_dish_ingredients.push({relationship: "primary", ingredient: res})
          that.input_text = ""
        error: (res) ->
          alert("Failed on adding new ingredient")
        )
)

Vue.component('family-member-dish-edit'
  props:
    initial_family_member_opinions:
      type: Array
      default: () ->
        return []
    initial_family_id:
      type: Number
  data: () ->
    return {
      family_id: this.initial_family_id
      family_member_opinions: this.initial_family_member_opinions
      family_members: []
      unselected_family_members: []
    }
  template: """
            <div class="family_member_dishes_section">
              <family-member-picker v-bind:family_members="this.unselected_family_members"
                                    v-model:family_members="this.unselected_family_members"
                                    v-on:input="select_family_member" />
              <family-member-opinion v-for="(family_member_opinion, index) in this.family_member_opinions"
                                          :key="family_member_opinion.id"
                                          :is_input="true"
                                          v-bind:family_member_opinion="family_member_opinions[index]"
                                          v-model:family_member_opinion="family_member_opinions[index]"
              />
            </div>
            """
  created: () ->
    this.get_family_members()
  methods:
    get_family_members: ->
      that = this
      $.ajax(
        url: "/family_members"
        data:
          family_id: that.family_id
        dataType: "json"
        success: (res) ->
          that.family_members = res
          that.unselected_family_members = that.family_members.filter (fm) ->
            not that.family_member_opinions.some (fmo) => fmo.family_member.id == fm.id
        error: (res) ->
          alert("Failed to get family members")
      )
    select_family_member: (selected_family_member) ->
      family_member_opinion = {
        family_id: this.family_id
        family_member: selected_family_member
      }
      this.family_member_opinions.push family_member_opinion
      this.unselected_family_members.splice this.unselected_family_members.indexOf(selected_family_member), 1

)

Vue.component('family-member-opinion'
  props:
    family_member_opinion:
      type: Object
      required: true
    is_input:
      type: Boolean
      default: true
  data: () ->
    return {
      icon_enjoyment:
        src: "assets/icon_heart.svg"
        title: "Enjoyment"
      icon_cooking_ability:
        src: "assets/icon_chef.svg"
        title: "Cooking Ability"
    }
  template: """
            <div class="family_member_opinion_form">
              <div class="opinion_form_left">
                <family-member-circle v-bind:first_name="family_member_opinion.family_member.first_name" />
                <div class="clear"></div>
                <dot-gauge v-bind:initial_value="family_member_opinion.enjoyment_level"
                           v-bind:icon="icon_enjoyment"
                           v-bind:label_width="16"
                           v-bind:is_input="is_input"
                           v-model="family_member_opinion.enjoyment_level"
                />
                <dot-gauge v-bind:initial_value="family_member_opinion.cooking_ability_level"
                           v-bind:icon="icon_cooking_ability"
                           v-bind:label_width="16"
                           v-bind:is_input="is_input"
                           v-model="family_member_opinion.cooking_ability_level"
                           v-if="family_member_opinion.family_member.can_cook"
                />
                <div class="clear"></div>
              </div>
              <div class="opinion_form_right">
                <textarea v-if="is_input" v-model="family_member_opinion.note" placeholder="Add notes here..." />
                <div v-else>{{family_member_opinion.note}}</div>
              </div>
              <div class="clear"></div>
            </div>
            """
)

#Vue.component('add_ingredient_selector'
#)
