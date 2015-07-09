var alertError, apply_toggled_field, hashToJson, hideResetLink, history, showResetLink, toggle_field, ucfirst;

history = [];

hashToJson = function() {
  var hash, hashObj, i, query;
  if (!window.location.hash) {
    return {};
  }
  hash = window.location.hash.replace(/#/, "").split("&");
  hashObj = {};
  for (i in hash) {
    query = hash[i].split("=");
    hashObj[query[0]] = query[1];
  }
  return hashObj;
};

ucfirst = function(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
};

hideResetLink = function() {
  $("#project_form").find(".or_new_project").hide();
};

showResetLink = function() {
  $("#project_form").find(".or_new_project").show();
};

alertError = function(jqXHR, textStatus, errorThrown) {
  var error_info, error_text, field_name, i;
  error_info = void 0;
  error_text = void 0;
  i = void 0;
  error_info = $.parseJSON(jqXHR.responseText);
  error_text = "Validation:";
  for (i in error_info) {
    if (i === "status_comment") {
      field_name = "Status Comment";
    } else if (i === "abc") {
      field_name = "Client Category";
    } else {
      field_name = $("label[for$=" + i + "]").text();
    }
    error_text += '\n -- "' + field_name + '" ' + error_info[i];
  }
  alert(error_text);
};

toggle_field = function(e, obj, el_id) {
  var id, val;
  if ($(obj).attr("action") === "edit") {
    $("[" + el_id + "=" + $(obj).attr("id") + "]").off(e);
    val = $(obj).text();
    id = $(obj).attr(el_id);
    $(obj).html("<input type=\"text\" size=\"" + $(obj).attr("size") + "\" value=\"" + val + "\"/> "
              + "<img src=\"/assets/apply.png\" action=\"apply\" id=\"" + id + "\"/>");
  }
};

apply_toggled_field = function(e, obj, el_id, path) {
  var td = $("[" + el_id + "=" + $(obj).attr("id") + "]")
  var val = td.find("input").val();
  $.post(path + $(obj).attr("id"), {
    value: val
  });
  td.html(val);
  td.bind("click", function(e){ toggle_field(e, this, el_id, $(this).attr('size')) });
};
