# controls.coffee
# Generic code for controls

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