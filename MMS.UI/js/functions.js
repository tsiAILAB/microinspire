$.fn.MakeNumber = function (scale, align) {
  if (!scale) scale = 0;
  $(this)
    .css({ "text-align": align || "right" })
    .keydown(function (e) {
      var inpuVal = $(this).val();
      var keys = [46, 8, 9, 27, 13, 109, 173, 189];
      if (scale > 0) {
        keys.push(110);
        keys.push(190);
      }
      // Allow: backspace, delete, tab, escape, enter and .
      if (
        $.inArray(e.keyCode, keys) !== -1 ||
        // Allow: Ctrl+A,Ctrl+C,Ctrl+V, Ctrl+A
        ((e.keyCode === 65 ||
          e.keyCode === 86 ||
          e.keyCode === 88 ||
          e.keyCode === 90 ||
          e.keyCode === 67) &&
          (e.ctrlKey === true || e.metaKey === true)) ||
        // Allow: home, end, left, right, down, up
        (e.keyCode >= 35 && e.keyCode <= 40)
      ) {
        // let it happen, don't do anything
        if (
          (e.keyCode === 110 || e.keyCode === 190) &&
          inpuVal.indexOf(".") !== -1
        ) {
          e.preventDefault();
        } else if (
          e.keyCode === 109 ||
          e.keyCode === 173 ||
          e.keyCode === 189
        ) {
          var pos = GetCaretPosition(this);
          if (pos.end !== 0 || inpuVal.indexOf("-") !== -1) e.preventDefault();
          else return;
        } else return;
      }

      // Ensure that it is a number and stop the keypress
      if (
        (e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) &&
        (e.keyCode < 96 || e.keyCode > 105)
      ) {
        e.preventDefault();
      }
      if (scale > 0) {
        var curPos = GetCaretPosition(this);
        if (curPos.start !== curPos.end) return;
        var prevText = GetPrevText(inpuVal, curPos.end);
        if (prevText.indexOf(".") !== -1) {
          var decimalCheck = inpuVal.split(".");
          if (typeof decimalCheck[1] !== "undefined") {
            if (decimalCheck[1].length > 1) e.preventDefault();
          }
        }
      }
    });
  $(this).keypress(function (e) {
    if (e.keyCode === 32) {
      e.preventDefault();
    }
  });
  $(this).on("paste", function () {
    var that = $(this);
    setTimeout(function () {
      var val = that.val();
      if (scale && scale > 0) val = val.replace(/(?!^-)[^0-9\.]/g, "");
      else val = val.replace(/(?!^-)[^0-9]/g, "");
      var decimalCheck = val.split(".");
      if (typeof decimalCheck[1] !== "undefined") {
        decimalCheck[1] = decimalCheck[1].slice(0, scale);
        val = decimalCheck[0] + "." + decimalCheck[1];
      }
      if (that.val() !== val) {
        that.val(val);
      }
    }, 1);
  });
};

function GetCaretPosition(el) {
  var start = 0,
    end = 0,
    normalizedValue,
    range,
    textInputRange,
    len,
    endRange;

  if (
    typeof el.selectionStart === "number" &&
    typeof el.selectionEnd === "number"
  ) {
    start = el.selectionStart;
    end = el.selectionEnd;
  } else {
    range = document.selection.createRange();

    if (range && range.parentElement() === el) {
      len = el.value.length;
      normalizedValue = el.value.replace(/\r\n/g, "\n");

      // Create a working TextRange that lives only in the input
      textInputRange = el.createTextRange();
      textInputRange.moveToBookmark(range.getBookmark());

      // Check if the start and end of the selection are at the very end
      // of the input, since moveStart/moveEnd doesn't return what we want
      // in those cases
      endRange = el.createTextRange();
      endRange.collapse(false);

      if (textInputRange.compareEndPoints("StartToEnd", endRange) > -1) {
        start = end = len;
      } else {
        start = -textInputRange.moveStart("character", -len);
        start += normalizedValue.slice(0, start).split("\n").length - 1;

        if (textInputRange.compareEndPoints("EndToEnd", endRange) > -1) {
          end = len;
        } else {
          end = -textInputRange.moveEnd("character", -len);
          end += normalizedValue.slice(0, end).split("\n").length - 1;
        }
      }
    }
  }

  return {
    start: start,
    end: end
  };
}

function GetPrevText(text, caretPos) {
  //var index = text.indexOf(caretPos);
  var preText = text.substring(0, caretPos);
  return preText;
}

Number.prototype.numberFormat = function (
  has_dec_point,
  decimals,
  dec_point,
  thousands_sep,
  leadingZeroLength
) {
  dec_point = typeof dec_point !== "undefined" ? dec_point : ".";
  thousands_sep = typeof thousands_sep !== "undefined" ? thousands_sep : ",";

  var parts = this.toFixed(decimals).split(".");

  if (leadingZeroLength) {
    while (parts[0].length < leadingZeroLength) {
      parts[0] = "0" + parts[0];
    }
  }

  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, thousands_sep);

  var formattedNumber = parts.join(dec_point);

  formattedNumber +=
    has_dec_point && parts.length === 1 && decimals > -1 ? dec_point : "";

  return formattedNumber;
};

function RoundNumber(num, dec) {
  var result = Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
  return result;
}

$.fn.CreateFileUploader = function () {
  var that = $(this);
  that.options = {};
  if (arguments && arguments.length !== 0) {
    that.options = arguments[0];
  }

  that.options.paramName = that.options.paramName || "uplodedfile";
  that.options.url = that.options.url || "/FileUpload/ImageUpload";
  that.options.allowedTypes = that.options.allowedTypes || "*";
  that.options.multiple = that.options.multiple === true ? "multiple" : "";
  that.options.keyName = that.options.keyName || "";

  var $file = $(
    '<input type="file" style="display: none;" ' + that.options.multiple + ">"
  );
  $file.appendTo($(document.body));
  that.on("click", function () {
    $file.trigger("click");
  });
  $file.change(function () {
    var input = this,
      numFiles = $(input).get(0).files ? $(input).get(0).files.length : 1;
    //var label = $(input).val().replace(/\\/g, '/').replace(/.*\//, '');
    var formData = new FormData();
    for (var i = 0; i < numFiles; i++) {
      var file = input.files[i];
      if (!IsFileTypeAllowed(that.options.allowedTypes, file.name)) {
        if (that.options.util)
          that.options.util.ShowMessageBox(
            "Extension",
            file.name +
            " has invalid extension. Only " +
            that.options.allowedTypes +
            " are allowed."
          );
        return;
      }
      formData.append(that.options.paramName, file);
    }
    $.ajax({
      type: "POST",
      url: that.options.url,
      data: formData,
      dataType: "json",
      contentType: false,
      processData: false,
      success: function (res) {
        if (that.options.onSuccess)
          that.options.onSuccess(input.files, res.Result);
      },
      error: function (error) {
        if (that.options.onError) that.options.onError(input.files, error);
      }
    });
  });
};
function IsFileTypeAllowed(allowedTypes, fileName) {
  var fileExtensions = allowedTypes.toLowerCase().split(",");
  var ext = fileName
    .split(".")
    .pop()
    .toLowerCase();
  if (allowedTypes !== "*" && jQuery.inArray(ext, fileExtensions) < 0) {
    return false;
  }
  return true;
}
