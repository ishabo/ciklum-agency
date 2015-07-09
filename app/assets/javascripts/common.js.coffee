jQuery ->

  autoCompleteProjectName = undefined
  hash_data = undefined
  resetForm = undefined
  upsertService = undefined
  $("[type=text], textarea").attr "x-webkit-speech", ""
  hash_data = window.hashToJson()
  $("a.fancybutton").button()
  $("a[_method=delete]").live "click", (e) ->
    e.preventDefault()
    $.ajax
      url: $(this).attr("href") + ".json"
      type: "DELETE"
      dataType: "json"
      success: (data) ->
        $("#services_list").dataTable().fnDraw()

    false

  autoCompleteProjectName = ->
    $("#project_name").autocomplete
      source: (request, response) ->
        $.ajax
          url: $("#project_form").attr("action") + ".json"
          dataType: "JSON"
          data:
            search: request.term

          success: (data) ->
            response $.map(data, (item) ->
              label: item.name
              id: item.id
              client: item.client
              project_manager: item.project_manager
              sales_manager: item.sales_manager
              hub_id: item.hub_id
              description: item.description
              budget: item.budget
              converted: item.converted
              engagement_type: item.engagement_type
            )


      minLength: 2
      select: (event, ui) ->
        showResetLink()
        $("#service_project_id").val ui.item.id
        $("#project_client").val ui.item.client
        $("#project_project_manager").val ui.item.project_manager
        $("#project_sales_manager").val ui.item.sales_manager
        $("#project_hub_id").val ui.item.hub_id
        $("#project_description").val ui.item.description
        $("#project_budget").val ui.item.budget
        $("#project_converted").val ui.item.converted
        $("#project_engagement_type").val ui.item.engagement_type
        history.original_projects_form = $("#project_form").attr("action")
        history.projects_form = $("#project_form").attr("action") + "/" + ui.item.id
        $("#project_form").attr "action", $("#project_form").attr("action") + "/" + ui.item.id


  $("a.fancybox").live "click", (e) ->
    e.preventDefault()
    history.service_form = $(this).attr("services_update_url")
    history.project_form = $(this).attr("projects_update_url")
    $.get $(this).attr("href"), (data) ->
      form_id = undefined
      $.fancybox data
      autoCompleteProjectName()  if $("#project_name").hasClass("allow_autocomplete")
      resetForm()
      upsertService()
      $(".datepicker").datepicker dateFormat: "yy-mm-dd"
      form_id = $(this).attr("form_id")
      $("#project_form").find("input[type=submit]").hide()
      $("#project_form").attr "action", history.project_form
      $("#service_form").attr "action", history.service_form
      hideResetLink()


  resetForm = ->
    $(".reset_form").click (e) ->
      form_id = undefined
      e.preventDefault()
      form_id = $(this).attr("form_id")
      $("#" + form_id).each ->
        @reset()

      hideResetLink()
      $("#" + form_id).attr "action", history.original_projects_form  if history.original_projects_form

  upsertService = ->
    $("#service_submit").click (event) ->
      event.preventDefault()
      $.ajax $("#project_form").attr("action") + ".json",
        type: (if $("#service_project_id").val() is "" then "POST" else "PUT")
        dataType: "JSON"
        data: $("#project_form").serialize()
        error: alertError
        success: (project_data, textStatus, jqXHR) ->
          project_form_href = undefined
          $("#service_project_id").val project_data.id
          project_form_href = $("#project_form").attr("action").replace(/projects$/, "projects/" + project_data.id)
          $("#project_form").attr "action", project_form_href
          $.ajax $("#service_form").attr("action") + ".json",
            type: "POST"
            dataType: "JSON"
            data: $("#service_form").serialize()
            error: alertError
            success: (service_data, textStatus, jqXHR) ->
              $('.pop-up').remove()
              $.fancybox.close()
              $("#services_list").dataTable().fnDraw()

  moveLeft = 100
  moveDown = 20
  $(".show_comment").live
    mouseenter: (e) ->
      $("#" + $(this).attr("popup_div")).show()
      $("#" + $(this).attr("popup_div")).appendTo('body')
    mouseleave: (e) ->
      $("#" + $(this).attr("popup_div")).hide()
    mousemove: (e) ->
      $("#" + $(this).attr("popup_div")).css('top', e.pageY + moveDown)
      $("#" + $(this).attr("popup_div")).css('left', e.pageX - moveLeft)
