# controls.coffee
# Generic code for controls

Vue.component('dot-gauge'
  props:
    is_input:
      type: Boolean
      default: true
    initial_value:
      type: Number
      default: () ->
        return 0
    max_value:
      type: Number
      default: () ->
        return 6
    icon:
      type: Object # Keys: src, title
    label_width:
      type: Number # Pixels
  data: () ->
    return {
      value: this.initial_value
    }
  template: """
            <div class="dot_gauge_form">
              <div :style="label_width && {width: label_width + 'px' }" class="dot_gauge_label">
                <img v-if="icon" :src="icon.src" :title="icon.title" class="dot_gauge_icon" />
                <slot></slot>
              </div>
              <div class="dot_gauge">
                <div class="dot" v-for="n in max_value" v-bind:class="{dot_filled: is_filled(n)}" v-on:click="select_value(n)"></div>
              </div>
            </div>
            """
  methods:
    is_filled: (n) ->
      return n <= this.value
    select_value: (n) ->
      if this.is_input
        this.value = n
        this.$emit('input', this.value)

  watch:
    initial_value: (val) ->
      this.value = val
)

Vue.component('date-picker'
  template: "<input/>"
  mounted: () ->
    self = this
    $(this.$el).datepicker({
      onSelect: (date) ->
        self.$emit('input', date)
    })
)

show_tab_content = (tab, tab_bar, content_div_id) ->
  content_container_div_id = tab_bar.data("for")
  content_container = tab_bar.siblings("#" + content_container_div_id)
  content_container.children(".tab_section").addClass("hidden")
  content_container.children("#" + content_div_id).removeClass("hidden")
  tab_bar.children(".tab").removeClass("tab_selected")
  tab.addClass("tab_selected")
  tab_bar.children(".selected_value").val(content_div_id)


$ ->
  $(".datepicker").datepicker()
  $(".tab_bar .tab").click ->
    show_tab_content($(this), $(this).parent(), $(this).data("for"))
