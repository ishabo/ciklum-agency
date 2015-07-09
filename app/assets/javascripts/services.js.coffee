# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

fnCreateSelect = (aData) ->
  r = "<select><option value=\"\"></option>"
  i = undefined
  iLen = aData.length
  i = 0
  while i < iLen
    r += "<option value=\"" + aData[i] + "\">" + aData[i] + "</option>"
    i++
  r + "</select>"
(($) ->
  $.fn.dataTableExt.oApi.fnGetColumnData = (oSettings, iColumn, bUnique, bFiltered, bIgnoreEmpty) ->
    return new Array()  if typeof iColumn is "undefined"
    bUnique = true  if typeof bUnique is "undefined"
    bFiltered = true  if typeof bFiltered is "undefined"
    bIgnoreEmpty = true  if typeof bIgnoreEmpty is "undefined"
    aiRows = undefined
    if bFiltered is true
      aiRows = oSettings.aiDisplay
    else
      aiRows = oSettings.aiDisplayMaster
    asResultData = new Array()
    i = 0
    c = aiRows.length

    while i < c
      iRow = aiRows[i]
      aData = @fnGetData(iRow)
      sValue = aData[iColumn]
      if bIgnoreEmpty is true and sValue.length is 0
        continue
      else if bUnique is true and jQuery.inArray(sValue, asResultData) > -1
        continue
      else
        asResultData.push sValue
      i++
    asResultData
) jQuery

append_to_search_filter = (filter, value) ->
  services_search_filter = $("#services_search_filter")
  if services_search_filter.val() != ''
    semi_colon = ";"
  else
    semi_colon = ""    
  services_search_filter.val(semi_colon + services_search_filter.val() + filter + ":" + value )
  $("#clear_field > img").removeClass('hidden')

cache = {}
cache.consultant = 0
cache.status = 0

jQuery ->
    hash_data = hashToJson()
    
    initServiceListDataTables = $('#services_list').dataTable 
        sPaginationType: "full_numbers"
        bJQueryUI: true
        bProcessing: true
        bServerSide: true
        bDestroy: true
        bRetrieve: true
        iDisplayLength: 100
        sAjaxSource: $("#services_list").data("source")
        fnServerData: (sSource, aoData, fnCallback) ->
            aoData.push
              name: "consultant"
              value: cache.consultant,
            aoData.push
              name: "status"
              value: cache.status
            $.getJSON sSource, aoData, (json) ->
              fnCallback json
        fnRowCallback: (nRow, aData, iDisplayIndex) ->
          get_class = $("td:eq(6)", nRow).find('img').attr('alt').toLowerCase()
          #$("td:eq(0)", nRow).parent().addClass('service_status_'+get_class)
          $('.pop-up').remove()
          nRow
        aaSorting: [[2, "desc"]]
        oLanguage:
            sSearch: "Search all columns:"

    #initServiceListDataTables.rowGrouping();


    if hash_data["status"]
      $("input:radio[name=by_status][status_str=" + hash_data["status"] + "]").attr('checked', true).trigger "click"
      cache.status = $("input:radio[name=by_status][status_str=" + hash_data["status"] + "]").val()

    $("#user_list").buttonset()

    $("#statuses_list").buttonset()

    $("input:radio[name=consultant]").live "click", ->
      cache.consultant = $(this).val()
      initServiceListDataTables._fnAjaxUpdate();

    $("input:radio[name=by_status]").live "click", ->
      cache.status = $(this).val()
      initServiceListDataTables._fnAjaxUpdate();

    $("tfoot th").each (i) ->
      @innerHTML = fnCreateSelect(initServiceListDataTables.fnGetColumnData(i))
      $("select", this).change ->
        initServiceListDataTables.fnFilter $(this).val(), i


    if hash_data["date"] and hash_data["consultant"]
      searchText = "date:" + hash_data["date"]
      
      if hash_data["service"]
        searchText += ";s:" + hash_data["service"]
      $("#services_list_filter").find('input:text').val searchText
      initServiceListDataTables.fnFilter searchText

    $("#services_list_filter").find("input[aria-controls]").css "width", "300px"
    $("#services_list_filter").find("input[aria-controls]").attr('id', 'services_search_filter')


    if hash_data["consultant"]
      if $.isNumeric(hash_data["consultant"])
        label = $("[for=consultant_" + hash_data["consultant"] + "]").find('span')
        consultant_button = $("input:radio[name=consultant][value=" + hash_data["consultant"] + "]")
        cache.consultant = hash_data["consultant"]
      else 
        consultant = ucfirst(hash_data["consultant"])
        consultant_button = $("input:radio[consultant_name*=" + consultant + "]")
        cache.consultant = consultant_button.val()
        label = $("[for=consultant_" + cache.consultant + "]").find('span')
      
      consultant_button.attr "checked", true
      label.trigger "click"
      append_to_search_filter('con', label.text()) if label.text() != 'All'
      initServiceListDataTables.fnFilter $("#services_search_filter").val() 

    if hash_data["project"]
      append_to_search_filter('project', hash_data["project"])
      initServiceListDataTables.fnFilter $("#services_search_filter").val()
    
    if hash_data["project_conversion"] || hash_data["pc"]
      append_to_search_filter('pc', hash_data["project_conversion"])
      initServiceListDataTables.fnFilter $("#services_search_filter").val() 

    $("#exclamation").live "click", ->
      $.fancybox $("#exclamation_info").html(),
        transitionIn: "elastic"
        transitionOut: "elastic"
        speedIn: 600
        speedOut: 200
        width: 500
        height: 500
        overlayShow: false

    $("#services_search_filter").bind "keyup change", ->
      if $("#services_search_filter").val() != ''
        $("#clear_field > img").removeClass('hidden')
      else
        $("#clear_field > img").addClass('hidden')

    $("#clear_field").live "click", ->
      $("#services_search_filter").val ""
      initServiceListDataTables.fnFilter ''
      $("#clear_field > img").addClass('hidden')
      false

