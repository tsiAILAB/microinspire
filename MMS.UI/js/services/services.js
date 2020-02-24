MicroInspireApp.factory("$utility", function ($appConst) {
  var utility = {};

  utility.HideWait = function () {
    var element = angular.element(".loadingparent");
    if (element.length) element.remove();
  };

  utility.ShowWait = function () {
    utility.HideWait();
    angular
      .element(document.body)
      .append(
        '<div class="loadingparent"><div class="circle"></div><div class="circle1"></div></div>'
      );
  };

  utility.PrintMessageInHeader = function (message) {
    noty({
      text: message,
      type: "information",
      dismissQueue: true,
      killer: true,
      layout: "top",
      theme: "defaultTheme",
      timeout: 3000
      //animation: {
      //    open: 'animated flipInX',
      //    close: 'animated flipOutX',
      //    easing: 'swing',
      //    speed: 500
      //}
    });
  };

  utility.PrintMessageInFooter = function (message) {
    noty({
      text: message,
      type: "error",
      dismissQueue: true,
      killer: true,
      layout: "bottom",
      theme: "defaultTheme"
      //animation: {
      //    open: 'animated flipInX',
      //    close: 'animated flipOutX',
      //    easing: 'swing',
      //    speed: 500
      //}
    });
  };

  utility.PrintMessage = function (layout, type, message) {
    noty({
      text: message,
      type: type,
      dismissQueue: true,
      killer: true,
      layout: layout,
      theme: "defaultTheme", //relax
      timeout: 5000
      //animation: {
      //    open: 'animated flipInX',
      //    close: 'animated flipOutX',
      //    easing: 'swing',
      //    speed: 500
      //}
    });
  };

  utility.ShowMessageBox = function (title, message, onOkClick) {
    BootstrapDialog.show({
      title: title,
      message: message,
      type: BootstrapDialog.TYPE_INFO,
      draggable: true,
      closable: true,
      closeByBackdrop: false,
      closeByKeyboard: true,
      buttons: [
        {
          label: "OK",
          cssClass: "btn-danger",
          action: function (dialogRef) {
            dialogRef.close();
            if (onOkClick) onOkClick();
          }
        }
      ]
    });
  };

  utility.ShowConfirmBox = function (title, message, onOkClick, onCancelClick) {
    BootstrapDialog.show({
      title: title,
      message: message,
      type: BootstrapDialog.TYPE_DANGER,
      draggable: true,
      closable: true,
      closeByBackdrop: false,
      closeByKeyboard: true,
      buttons: [
        {
          label: "Cancel",
          cssClass: "btn-danger",
          action: function (dialogRef) {
            dialogRef.close();
            if (onCancelClick) onCancelClick();
          }
        },
        {
          label: "OK",
          cssClass: "btn-primary",
          action: function (dialogRef) {
            dialogRef.close();
            if (onOkClick) onOkClick();
          }
        }
      ]
    });
  };

  utility.ShowDialog = function () {
    var self = this;
    self.options = {};
    if (arguments && arguments.length !== 0) {
      self.options = arguments[0];
    }
    self.options.title = self.options.title || "";
    self.options.autodestroy = self.options.autodestroy || false;

    BootstrapDialog.show({
      title: self.options.title,
      message: self.options.content,
      type: BootstrapDialog.TYPE_PRIMARY,
      autodestroy: false,
      draggable: true,
      closable: true,
      closeByBackdrop: false,
      closeByKeyboard: true,
      buttons: [
        {
          label: "Cancel",
          cssClass: "btn-danger",
          action: function (dialogRef) {
            dialogRef.close();
            if (self.options.onCancelClick) self.options.onCancelClick();
          }
        },
        {
          label: "OK",
          cssClass: "btn-primary",
          action: function (dialogRef) {
            dialogRef.close();
            if (self.options.onOkClick) self.options.onOkClick();
          }
        }
      ]
    });
  };

  utility.ErrorCallback = function (error) {
    utility.HideWait();
    if (error.status === -1) utility.PrintMessageInFooter("Server not found....");
    else if (error.data) utility.PrintMessageInFooter(utility.ParseError(error.data));
    else utility.PrintMessageInFooter("Internal server error....");
  };

  utility.HasException = function (data) {
    if (data && data.ResponseCode) {
      switch (data.ResponseCode) {
        case "APP_ERROR":
        case "BAD_REQUEST":
        case "NOT_FOUND":
        case "NO_CONTENT":
        case "UNAUTHORIZED":
        case "INTERNAL_ERROR":
        case "CONNECT_ERROR":
        case "FAILURE":
        case "SERVICE_UNAVAILABLE":
        case "CONNECT_TIMEOUT":
        case "VALIDATION":
          if (data.Message) utility.PrintMessageInFooter(data.Message);
          return true;
        default:
          return false;
      }
    }
    return false;
  };

  utility.ParseError = function (responseText) {
    if (typeof responseText === "object") {
      let msg = "";
      $.each(responseText, function (key, value) {
        msg += `${value}`
      });
      return msg;
    }
    else {
      var findex = responseText.indexOf("<title>");
      var sindex = responseText.indexOf("</title>");
      return responseText.substring(findex + 7, sindex).replace("924", "");
    }
  };

  utility.GetImagePath = function (imagePath) {
    if (imagePath)
      return $appConst.BaseUrl + imagePath + "?q=" + new Date().valueOf();
    else return utility.GetBlankImagePath();
  };

  utility.GetBlankImagePath = function () {
    return $appConst.BaseUrl + "/img/Blank.png?q=" + new Date().valueOf();
  };

  utility.GetDocumentPath = function (docPath) {
    if (docPath) return $appConst.BaseUrl + docPath;
    else return utility.GetBlankDocPath();
  };

  utility.GetBlankDocPath = function () {
    return $appConst.BaseUrl + "/img/UploadFile.png";
  };

  utility.GetFileExtensionImage = function (fileName) {
    return $appConst.BaseUrl + "/img/" + fileName;
  };

  utility.DaysInMonth = function (month, year) {
    var m = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month !== 2) return m[month - 1];
    if (year % 4 !== 0) return m[1];
    if (year % 100 === 0 && year % 400 !== 0) return m[1];
    return m[1] + 1;
  };

  utility.GetLastDateOfMonth = function (month, year) {
    return new Date(new Date(year, month, 1) - 1);
  };

  utility.makeArray = function (stringData) {
    return $.parseJSON(stringData);
  };

  utility.makeJsonString = function (arrayData) {
    return JSON.stringify(arrayData);
  };

  utility.RemoveParameterFromUrl = function (url, parameter) {
    return url
      .replace(new RegExp("[?&]" + parameter + "=[^&#]*(#.*)?$"), "$1")
      .replace(new RegExp("([?&])" + parameter + "=[^&]*&"), "$1");
  };

  utility.GetKeystring = function (url, key) {
    key = key.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + key + "=([^&#]*)");
    var qs = regex.exec(url);
    if (qs === null) return "";
    else return qs[1];
  };

  utility.GetQuerystring = function (key, defaultval) {
    if (defaultval === null) defaultval = "";
    key = key.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + key + "=([^&#]*)");
    var qs = regex.exec(window.location.href);
    if (qs === null) return defaultval;
    else return qs[1];
  };

  utility.RoundNumber = function (num, dec) {
    var result = Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
    return result;
  };

  utility.SplitCamelCase = function (string) {
    return string.replace(/([a-z])([A-Z])/g, "$1 $2");
  };

  utility.GetAge = function (dateString) {
    const today = new Date();
    const birthDate = dateString.toDate($appConst.SystemDateFormat);
    if (birthDate == "Invalid Date" || birthDate > today) return "";
    let age = today.getFullYear() - birthDate.getFullYear();
    const m = today.getMonth() - birthDate.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
      age--;
    }
    return age === 0 ? "" : age;
  };

  return utility;
});

MicroInspireApp.factory("$authUser", function () {
  var authUser = {};
  var userKey = "mms_user";
  var tokenKey = "mms_token";

  authUser.getUser = function () {
    const curUser = localStorage.getItem(userKey);
    if (curUser) return JSON.parse(curUser);
    else return null;
  };

  authUser.setUser = function (curUser) {
    localStorage.setItem(userKey, JSON.stringify(curUser));
  };

  authUser.getToken = function () {
    return localStorage.getItem(tokenKey);
  };

  authUser.setToken = function (idToken) {
    localStorage.setItem(tokenKey, idToken);
  };

  authUser.loggedIn = function () {
    const token = this.getToken();
    return !!token && !this.isTokenExpired(token);
  };

  authUser.logOut = function () {
    localStorage.removeItem(userKey);
    localStorage.removeItem(tokenKey);
  };

  authUser.isTokenExpired = function (token) {
    try {
      const decoded = this.decode(token);
      return decoded.exp < Date.now() / 1000;
    } catch (e) {
      return true;
    }
  };
  authUser.decode = function (token) {
    var claims = {};
    if (typeof token !== "undefined") {
      var encoded = token.split(".")[1];
      claims = JSON.parse(this.urlBase64Decode(encoded));
    }
    return claims;
  };
  authUser.urlBase64Decode = function (str) {
    var output = str.replace("-", "+").replace("_", "/");
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += "==";
        break;
      case 3:
        output += "=";
        break;
      default:
        throw "Illegal base64url string!";
    }
    return window.atob(output);
  };

  return authUser;
});
