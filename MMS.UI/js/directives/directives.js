MicroInspireApp.directive("mnCheck", function ($timeout, $parse) {
  return {
    restrict: "A",
    require: "ngModel",
    link: function ($scope, element, $attrs, ngModel) {
      if (!element[0].type) return;
      return $timeout(function () {
        var value;
        value = $attrs["value"];
        if (value === undefined) value = "";

        $scope.$watch($attrs["ngModel"], function (newValue) {
          element.iCheck("update");
        });
        $scope.$watch($attrs["ngDisabled"], function (newValue) {
          element.iCheck(newValue ? "disable" : "enable");
          element.iCheck("update");
        });

        return element
          .iCheck({
            checkboxClass: "icheckbox_minimal-blue",
            radioClass: "iradio_minimal-blue",
            increaseArea: "20%"
          })
          .on("ifChanged", function (event) {
            if (element.attr("type") === "checkbox" && $attrs["ngModel"]) {
              $scope.$apply(function () {
                return ngModel.$setViewValue(event.target.checked);
              });
            }
            if (element.attr("type") === "radio" && $attrs["ngModel"]) {
              return $scope.$apply(function () {
                return ngModel.$setViewValue(value);
              });
            }
          });
      });
    }
  };
});

MicroInspireApp.directive("mnNumber", function () {
  return {
    restrict: "A",
    require: "ngModel",
    link: function (scope, element, attrs) {      
      let scale = parseInt(attrs.scale);
      if (scale && scale > 0) element.MakeNumber(scale, attrs.talign);
      else element.MakeNumber(0, attrs.talign);
    }
  };
});

MicroInspireApp.directive("mnShowmax", function () {
  return {
    restrict: "A",
    link: function ($scope, element, attrs) {
      if (!element[0].type) return;
      element.maxlength({
        alwaysShow: true,
        threshold: 10,
        warningClass: "label label-success",
        limitReachedClass: "label label-danger",
        separator: " of ",
        preText: " ",
        postText: " characters used.",
        validate: true
      });
    }
  };
});

MicroInspireApp.directive("mnDate", function ($appConst) {
  return {
    restrict: "A",
    link: function ($scope, $element, $attrs) {
      let startDate = -Infinity;
      let endDate = Infinity;
      if ($attrs.startDate === "0d") startDate = new Date();
      if ($attrs.endDate === "0d") endDate = new Date();
      $element
        .datepicker({
          format: $appConst.SystemDateFormat,
          startDate: startDate,
          endDate: endDate
        })
        .on("show", function () {
          if ($element.find("input").attr("readonly")) {
            $element.datepicker("hide");
          }
        });

      var dateEl = $element.children("input");
      var dateModel = angular.element(dateEl).controller("ngModel");

      $scope.$watch(
        function (scope) {
          return dateModel.$modelValue;
        },
        function (newValue, oldValue) {
          if (newValue == undefined) newValue = "";
          $element.datepicker("setDate", newValue);
        }
      );

      //element.datepicker()
      //    .on('changeDate', function (ev) {
      //        var dd = ev;
      //    });
    }
  };
});

MicroInspireApp.directive("ngEnter", function () {
  //a directive to 'enter key press' in elements with the "ng-enter" attribute

  return function (scope, element, attrs) {
    element.bind("keydown keypress", function (event) {
      if (event.which === 13) {
        scope.$apply(function () {
          scope.$eval(attrs.ngEnter);
        });

        event.preventDefault();
      }
    });
  };
});

MicroInspireApp.directive("mnClient", function ($utility) {
  return {
    restrict: "E",
    templateUrl: "pages/client.html",
    scope: {
      model: "=",
      oncancel: "=",
      onupdate: "="
    },
    link: function ($scope, element, attr) {
      $scope.eleId = attr.eleid;
      $scope.birthDateChanged = function () {
        $scope.model.AgeAtCreationDate = $utility.GetAge(
          $scope.model.DateofBirth
        );
      };
    }
  };
});

MicroInspireApp.directive("mnPayment", function ($utility) {
  return {
    restrict: "E",
    templateUrl: "pages/payment.html",
    scope: {
      model: "=",
      oncancel: "=",
      onupdate: "=",
      payeenames: "="
    },
    link: function ($scope, element, attr) {
      $scope.eleId = attr.eleid;
      $scope.PayeeTypes = [
        ...new Set($scope.payeenames.map(t => t.ClientType))
      ];
      $scope.Names = $scope.payeenames.filter(n => n.ClientType === $scope.model.PayeeType);
      if ($scope.model.PayeeId)
        $scope.model.PayeeId = $scope.model.PayeeId.toString();
      $scope.typeChanged = function () {
        $scope.Names = $scope.payeenames.filter(n => n.ClientType === $scope.model.PayeeType);
      };
      $scope.onCancel = function ($payment) {
        $scope.oncancel($payment)
        $scope.Names = $scope.payeenames.filter(n => n.ClientType === $scope.model.PayeeType);
      };
    }
  };
});
