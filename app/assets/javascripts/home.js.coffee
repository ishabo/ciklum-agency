objects = {}
filter_result = []
fetch_won_vs_lost_vs_potential = undefined
fetch_revenue = undefined
root_path = "/?format=json"
filter_result.year = new Date().getFullYear()
filter_result.consultant = 0

thousandstok = (data) ->
  i = 0
  data[i] = Math.round(data[i] / 1000)  while i < data.length

dataLablesOptions =
  enabled: true
  rotation: 0
  color: "#FFFFFF"
  align: "right"
  x: -1
  y: 15
  width: 10
  formatter: ->
    @y

  style:
    fontSize: "8px"
    fontFamily: "Verdana, sans-serif"

  moredata: "bla"

displayHideUsers = (display, hide) ->
  $("input[position]").each (index) ->
    if $(this).attr("position") is hide
      $(this).hide()
      $("label[for=" + $(this).attr("id") + "]").hide()
    if $(this).attr("position") is display
      $(this).show()
      $("label[for=" + $(this).attr("id") + "]").show()
    return
  return


toggle_chart_vs_table = (checked, chart, table, delay) ->
  if checked is true
    if delay > 0
      $("#" + chart).hide "slide", {}, delay, ->
        $("#" + table).show "slide", {}, delay

    else
      $("#" + chart).hide()
      $("#" + table).show()
  else
    if delay > 0
      $("#" + table).hide "slide", {}, delay, ->
        $("#" + chart).show "slide", {}, delay

    else
      $("#" + table).hide()
      $("#" + chart).show()	 
  return

moveFilters = (ui) ->
	if $('#toggle_chart_vs_table').is(':checked') 
		do_table_chart_toggle(false, 0)

	if typeof objects.filters is 'undefined'
		objects.filters = $("#filters").html()
		$("#filters").html('')
	if typeof ui.newPanel != 'undefined'
		id = $(ui.newPanel).prop('id')
		old_id = $(ui.oldPanel).prop('id')
	else if typeof ui.panel != 'undefined'
		id = $(ui.panel).prop('id')
		old_id = id

	$('#' + old_id).find('.filters').html('')
	$('#' + id).find('.filters').html objects.filters
	$('#years_list').buttonset()
	$('#user_list').buttonset()
	$('#toggle_chart_vs_table').button()
	if id is 'tabs-2'
		displayHideUsers('TBC', 'UXD')
	else if id is 'tabs-3'
		displayHideUsers('UXD', 'TBC')
	filter_result.tab_id = id

	filter_result.year = new Date().getFullYear()
	$('#by_consultant_0').trigger 'click'
	$("input:radio[id=year_"+filter_result.year+"]").trigger "click"
	fetch filter_result.tab_id, "chart"

	return

showAllUsers = () ->
  $("input[position]").each (index) ->
    $(this).show()
    $("label[for=" + $(this).attr("id") + "]").show()
    return
  return


createDataTable = (service, data, title) ->
  possible_objects = undefined
  services_table = undefined
  total = undefined
  services_table = "" + "<div class='data_table_title'>" + title + "</div>" + "<table class='chart_data_table alternate'>"
  services_table += "<tr><td>Months</td>"
  i = 0
  while i < 12
    services_table += "<td>" + data.get_months[i] + "</td>"
    i++
  services_table += "</tr>"
  possible_objects = ["won", "completed", "lost", "potential", "booked"]
  for y of possible_objects
    obj = possible_objects[y]
    continue  if typeof data[obj] is "undefined"
    services_table += "<tr><td>" + obj + "</td>"
    i = 0
    while i < 12
      services_table += "<td>" + data[obj][i] + "</td>"
      i++
    services_table += "</tr>"
  services_table += "<tr><td><b>Total</b></td>"
  i = 0
  while i < 12
    total = 0
    for y of possible_objects
      obj = possible_objects[y]
      total += parseInt(data[obj][i])  if typeof data[obj] isnt "undefined"
    services_table += "<td><b>" + total + "</b></td>"
    i++
  services_table += "</tr></table><br /><br /><br />"
  $("#" + service + "_table").html services_table
  return

do_table_chart_toggle = (bool, delay) ->
  toggle_chart_vs_table bool, "ws_chart", "ws_table", delay
  toggle_chart_vs_table bool, "ux_chart", "ux_table", delay
  toggle_chart_vs_table bool, "conversion_rev_chart", "conversion_rev_table", delay
  #toggle_chart_vs_table bool, "vas_rev_chart", "vas_rev_table", delay
  toggle_chart_vs_table bool, "ws_rev_chart", "ws_rev_table", delay
  toggle_chart_vs_table bool, "ux_rev_chart", "ux_rev_table", delay
  return

won_vs_lost_vs_potential_charts = (div, title, yaxis_title, months, data, max_num) ->
  $("#" + div.replace("_chart", "_table")).find(".data_table_title").html title
  new Highcharts.Chart(
    chart:
      renderTo: div
      type: "column"
      spacingBottom: 30

    title:
      text: title

    xAxis:
      categories: months
      labels:
        rotation: -45
        align: "right"
        style:
          fontSize: "10px"
          fontFamily: "Verdana, sans-serif"

    yAxis:
      min: 0
      max: max_num
      title:
        text: yaxis_title

    plotOptions:
      series:
        cursor: "pointer"
        point:
          events:
            click: ->
              window.location = "/services#date=" + @category + "&consultant=" + filter_result.consultant + "&status=" + @series.options.composition.stat + "&service_type=" + @series.options.composition.service

    tooltip:
      formatter: ->
        "<b>" + @x + "</b><br/>" + " "

    series: data
  )
  return


revenue_chart = (div, title, yaxis_title, months, data) ->
  $("#" + div.replace("_chart", "_table")).find(".data_table_title").html title
  new Highcharts.Chart(
    chart:
      renderTo: div
      type: "column"

    title:
      text: title

    xAxis:
      categories: months
      labels:
        style:
          fontSize: "10px"
          fontFamily: "Verdana, sans-serif"

    yAxis:
      title:
        text: yaxis_title
      stackLabels:
        enabled: true

    plotOptions:
      column:
        stacking: "normal"
        dataLabels:
          enabled: true
          color: (Highcharts.theme and Highcharts.theme.dataLabelsColor) or "white"

    legend:
      align: "right"
      x: -70
      verticalAlign: "top"
      y: 20
      floating: true
      backgroundColor: (Highcharts.theme and Highcharts.theme.legendBackgroundColorSolid) or "white"
      borderColor: "#CCC"
      borderWidth: 1
      shadow: true

    tooltip:
      formatter: ->
        "<b>" + @x + "</b><br/>" + @series.name + ": " + Math.round(@y) + "K<br/>" + "Total: " + @point.stackTotal

    series: data
  )
  return

fetch = (tab, what_to_display) ->
  if tab is "tabs-2"
    fetch_won_vs_lost_vs_potential "ws", what_to_display
  else if tab is "tabs-3"
    fetch_won_vs_lost_vs_potential "ux", what_to_display
  else if tab is "tabs-4"
    fetch_revenue "ws", what_to_display
    fetch_revenue "ux", what_to_display
    #fetch_revenue "vas", what_to_display
    fetch_revenue "conversion", what_to_display
  return

fetch_won_vs_lost_vs_potential = (service_type, what_to_display) ->
  $.get root_path,
    year: filter_result.year
    service_type: service_type
    consultant: filter_result.consultant
  , (data) ->
    max_num = data.max
  	
    if service_type is "ws"
      uf_service = "workshop|T&TR"
    else
      uf_service = service_type
    
    series_data = [
      name: "Completed :)"
      data: data.won
      dataLabels: dataLablesOptions
      pointWidth: 13
      color: "#2DC444" #green
      composition:
        stat: "completed"
        service_type: uf_service
    ,
      name: "Lost :("
      data: data.lost
      dataLabels: dataLablesOptions
      pointWidth: 13
      color: "#D65C5C" #red
      composition:
        stat: "lost"
        service_type: uf_service
    ,
      name: "Potential :S"
      data: data.potential
      dataLabels: dataLablesOptions
      pointWidth: 13
      color: "#6278D1" #blue
      composition:
        stat: "potential"
        service_type: uf_service
    ,
      name: "Booked + In progress!!!"
      data: data.booked
      dataLabels: dataLablesOptions
      pointWidth: 13
      color: "#AA4BC9" #purple
      composition:
        stat: "booked"
        service_type: uf_service
    ]
    
    xtitle = undefined
    ytitle = undefined
    if service_type is "ws"
      ytitle = "Number of Workshops"
      xtitle = "Workshops"
    else if service_type is "vas"
      ytitle = "Number of VAS"
      xtitle = "Value Added Services"
    else if service_type is "ux"
      ytitle = "Number of UX"
      xtitle = "UX-UI"

    if what_to_display is 'chart'
      won_vs_lost_vs_potential_charts service_type + "_chart", xtitle, ytitle, data.get_months, series_data, max_num
    else if what_to_display is 'table'
      createDataTable service_type, data, xtitle + " - " + ytitle
    return
  return


fetch_revenue = (service_type, what_to_display) ->
  $.get root_path,
    year: filter_result.year
    service_type: service_type
    consultant: filter_result.consultant
    revenue: 1
  , (data) ->
    series_data = [
      name: "Potential"
      data: data.potential
    ,
      name: "Lost potential"
      data: data.lost
    ,
      name: "Converted :)"
      data: data.completed
    ]
    if service_type is "ws"
      ytitle = ""
      xtitle = "Workshop Revenue"
    else if service_type is "vas"
      ytitle = ""
      xtitle = "VAS Revenue"
    else if service_type is "ux"
      ytitle = ""
      xtitle = "UX Revenue"
    else if service_type is "conversion"
      ytitle = "Revenue"
      xtitle = "Project Converted Revenue"
    if what_to_display is 'chart'
      revenue_chart service_type + "_rev_chart", xtitle, ytitle, data.get_months, series_data
    else if what_to_display is 'table'
      createDataTable service_type + "_rev", data, xtitle + " - " + ytitle
    return
  return


jQuery ->
  $("#dashboard-tabs").tabs
    activate: (event, ui) -> moveFilters(ui)
    create: (event, ui) -> moveFilters(ui)

  $("#toggle_chart_vs_table").attr "checked", false

  $("#toggle_chart_vs_table").live "click", ->
  	if $(this).is(":checked")
  	  what_to_display = "table"
  	else
  	  what_to_display = "chart"
    fetch(filter_result.tab_id, what_to_display)  	
    do_table_chart_toggle $(this).is(":checked"), 500

  $("#year_" + new Date().getFullYear()).attr "checked", "checked"

  $("#years_list").buttonset()
  $("#user_list").buttonset()
  
  $("input:radio[name=year]").live "click", ->
    filter_result.year = $(this).val()
    fetch(filter_result.tab_id, "chart")
    fetch(filter_result.tab_id, "table")
    return

  $("input:radio[name=by_consultant]").live "click", ->
    filter_result.consultant = $(this).val()
    fetch(filter_result.tab_id, "chart")
    fetch(filter_result.tab_id, "table")
    return

  $(".availability").live "click", (e)->
    toggle_field(e, this, 'user_id', 6)

  $("img[action=apply]").live "click",(e) ->
    apply_toggled_field(e, this, 'user_id', '/update_user_availability/')


