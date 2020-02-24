MicroInspireApp.controller("BaseController", function (
  $scope,
  $config,
  $http,
  $compile,
  $timeout,
  $utility,
  $finder,
  $appConst
) {
  const ModelState =
  {
    Added: 1,
    Modified: 2,
    Deleted: 3,
    Unchanged: 4,
    Detached: 5,
    Archived: 6
  };
  var defaults = {
    keyField: "",
    displayField: "",
    newIDString: $appConst.NewIDString,
    loadUrl: "-",
    saveUrl: "-",
    deleteUrl: "-",
    showNew: false,
    showSearch: false,
    showSearchText: false,
    showProcess: false,
    showSave: false,
    showDelete: false,
    showClear: false,
    showFooter: true,
    autoClear: true,
    autoNew: false,
    showSuccessfullyMsg: true,
    validateBinded: true,
    buttons: [],
    afterNew: function () { },
    onSelect: function (data) {
      return true;
    },
    beforeSearch: function (finder) {
      return true;
    },
    beforeFill: function (model) {
      return true;
    },
    beforeLoad: function (primaryId) { },
    afterLoad: function (model) { },
    processData: function () {
      return true;
    },
    beforeSave: function (model) {
      return true;
    },
    afterSave: function (model) {
      return true;
    },
    beforeDelete: function (primaryId, model) {
      return true;
    },
    afterDelete: function (primaryId) { },
    afterClear: function () { }
  };

  $config = angular.extend({}, defaults, $config);
  if (typeof $config.id === "object" && $config.id !== null)
    $scope.$el = $($config.id);
  else $scope.$el = $("#" + $config.id);

  $scope.Model = {};

  $scope.InitButton = function () {
    var buttons = "";
    if ($config.showNew)
      buttons +=
        '<button class="btn btn-default btn-Main" title="New" ng-click="New()"><i class="fa fa-file-o"></i> New</button>';
    if ($config.showSearch)
      buttons +=
        '<button class="btn btn-default btn-Main" title="Search" ng-click="ShowFinder()"><i class="fa fa-search"></i> Search</button>';
    if ($config.showSave)
      buttons +=
        '<button class="btn btn-default btn-Main" title="Save" ng-click="Save()"><i class="fa fa-save"></i> Save</button>';
    if ($config.showDelete)
      buttons +=
        '<button class="btn btn-default btn-Main" title="Delete" ng-click="Delete()"><i class="fa fa-trash"></i> Delete</button>';
    if ($config.showProcess)
      buttons +=
        '<button class="btn btn-default btn-Main" title="Process" ng-click="Process()"><i class="fa fa-compressed"></i> Process</button>';
    if ($config.showClear)
      buttons +=
        '<button class="btn btn-default btn-Main" title="Clear" ng-click="Clear()"><i class="fa fa-eraser"></i> Clear</button>';
    var $buttons = angular.element("#footerContainer");
    $buttons.empty();
    $buttons.append($compile(buttons)($scope));

    var containerInput = $scope.$el.find('input[data-newbtn="true"]');
    if (containerInput.length) {
      containerInput.parent().addClass("input-group input-group-xs");
      $("<span class='input-group-btn'></span>")
        .insertAfter(containerInput)
        .append(
          $compile(
            '<button title="New" class="btn btn-default" ng-click="New()"><i class="fa fa-file-o"></i></button>'
          )($scope)
        );
    }
    containerInput = $scope.$el.find('input[data-searchbtn="true"]');
    if (containerInput.length) {
      if (containerInput.parent().hasClass("input-group")) {
        containerInput
          .nextAll("span:first")
          .append(
            $compile(
              '<button title="Search" class="btn btn-default" ng-click="ShowFinder()"><i class="glyphicon glyphicon-search"></i></button>'
            )($scope)
          );
      } else {
        containerInput.parent().addClass("input-group input-group-xs");
        $("<span class='input-group-btn'></span>")
          .insertAfter(containerInput)
          .append(
            $compile(
              '<button title="Search" class="btn btn-default" ng-click="ShowFinder()"><i class="glyphicon glyphicon-search"></i></button>'
            )($scope)
          );
      }
    }

    if ($config.buttons) {
      $.each($config.buttons, function (i, button) {
        var $button = $("<button/>")
          .addClass(
            button.addClass ? button.addClass : "btn btn-default btn-Main"
          )
          .html('<i class="fa fa-' + button.icon + '"></i> ' + button.text)
          .attr("title", button.title ? button.title : button.text)
          .appendTo($buttons)
          .on("click", function (event) {
            if ($.isFunction(button.onClick)) {
              button.onClick.call($button, event);
            }
          });
      });
    }
  };

  $scope.Init = function () {
    if ($config.showFooter) $scope.InitButton();
    else angular.element("#footerContainer").hide();
    if ($config.autoNew)
      $timeout(function () {
        $scope.New();
      }, 1000);

    if ($config.showSearchText && $config.search) {
      $config.search.maxResult = $config.search.maxResult || 10;
      $("#nav-search").append(
        "<span class='input-icon'><input type='text' placeholder='Search ...' class='nav-search-input' id='nav-search-input' autocomplete='off' /><i class='ace-icon fa fa-search nav-search-icon'></i></span>"
      );
      $("#nav-search-input").typeahead({
        minLength: 1,
        maxItem: $config.search.maxResult,
        order: "asc",
        dynamic: true,
        hint: true,
        delay: 500,
        cache: true,
        emptyTemplate: 'No result for "{{query}}"',
        display: $config.search.display,
        template: function (query, item) {
          return $config.search.template;
        },
        source: {
          search: {
            url: [
              {
                type: "POST",
                url: $config.search.url,
                data: {
                  query: "{{query}}",
                  total: $config.search.maxResult,
                  extraParams: $config.search.extraParams
                },
                callback: {
                  done: function (data) {
                    return data;
                  }
                }
              },
              "data"
            ]
          }
        },
        callback: {
          onClick: function (node, a, item, event) {
            if ($config.onSelect && $config.onSelect(item)) {
              if ($config.keyField && $config.keyField !== "") {
                var keyId = item[$config.keyField];
                if (keyId) $scope.Load(keyId);
              }
            }
            $timeout(function () {
              $("#nav-search-input").val("");
            }, 1);
          }
        }
      });
    }

    $scope.$el.validationEngine({
      promptPosition: "bottomLeft",
      autoPositionUpdate: true,
      binded: $config.validateBinded
    });
  };

  $scope.New = function () {
    $utility.ShowWait();
    if ($config.autoClear) $scope.Clear();
    else $scope.$el.validationEngine("hide");
    $utility.HideWait();

    if ($config.newIDString)
      $scope.Model[$config.keyField] = $config.newIDString;
    if ($config.displayField)
      $scope.Model[$config.displayField] = $config.newIDString;
    if ($config.afterNew) $config.afterNew();
    $scope.Model.ModelState = ModelState.Added;
  };

  $scope.Load = function (primaryId) {
    $utility.ShowWait();
    if ($config.beforeLoad) $config.beforeLoad(primaryId);

    $http({
      method: "GET",
      url: `${$config.loadUrl}/${primaryId}`,
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      var result = res.data.Result;
      var manualFill = false;
      if ($config.beforeFill && $config.beforeFill(result))
        $scope.Model = result;
      else manualFill = true;

      if (
        !manualFill &&
        (!result[$config.keyField] ||
          result[$config.keyField] === $appConst.IntMinValue)
      ) {
        $scope.Model.ModelState = ModelState.Added;
        if (!result[$config.keyField]) {
          if ($config.newIDString)
            $scope.Model[$config.keyField] = $config.newIDString;
          if ($config.displayField)
            $scope.Model[$config.displayField] = $config.newIDString;
        }
      } else $scope.Model.ModelState = ModelState.Modified;

      $scope.$el.validationEngine("hide");
      if ($config.afterLoad) $config.afterLoad(result);
    }, $utility.ErrorCallback);
  };

  $scope.Process = function () {
    if (!$scope.$el.validationEngine("validate")) return;
    if ($scope.processData && !$scope.processData()) return;
  };

  $scope.Save = function () {
    var isNew = false;
    if (!$scope.$el.validationEngine("validate")) return;
    if (
      $config.newIDString &&
      $scope.Model[$config.keyField] === $config.newIDString
    ) {
      $scope.Model[$config.keyField] = "";
      isNew = true;
    }

    if ($config.beforeSave && !$config.beforeSave($scope.Model)) {
      if (isNew) $scope.Model[$config.keyField] = $config.newIDString;
      return;
    }

    $utility.ShowWait();

    $http({
      method: "POST",
      url: $config.saveUrl,
      data: JSON.stringify($scope.Model)
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      if ($config.showSuccessfullyMsg)
        $utility.PrintMessageInHeader($appConst.SavedSuccessfullyMsg);
      if ($config.afterSave && $config.afterSave(res.data.Result)) {
        $scope.Model = res.data.Result;
      }
      $scope.Model.ModelState = ModelState.Modified;
    }, $utility.ErrorCallback);
  };

  $scope.Delete = function () {
    if (!$scope.$el.validationEngine("validate")) return;
    var primaryId = $scope.Model[$config.keyField];
    if (
      primaryId === undefined ||
      primaryId === "" ||
      primaryId === $config.newIDString ||
      primaryId === "0" ||
      parseInt(primaryId) === $appConst.IntMinValue
    )
      return;

    $scope.Model.ModelState = ModelState.Deleted;
    if ($config.beforeDelete && !$config.beforeDelete(primaryId, $scope.Model))
      return;

    $utility.ShowConfirmBox(
      "Delete Confirmation",
      "Are you sure you want to permanently delete info?",
      function () {
        $utility.ShowWait();
        $http({
          method: "POST",
          url: $config.deleteUrl,
          data: JSON.stringify($scope.Model)
        }).then(function (res) {
          $utility.HideWait();
          if ($utility.HasException(res.data)) return;
          $scope.Clear();
          if ($config.showSuccessfullyMsg)
            $utility.PrintMessageInHeader($appConst.DeletedSuccessfullyMsg);
          if ($config.afterDelete) $config.afterDelete(primaryId);
        }, $utility.ErrorCallback);
      }
    );
  };

  $scope.ShowFinder = function () {
    if ($config.searchFunc) {
      if ($config.beforeSearch && !$config.beforeSearch($config.searchFunc))
        return;
      var args = $config.searchFunc.options || {};
      args.onSelect = function (selectedData) {
        if ($config.keyField && $config.keyField !== "") {
          var keyId = selectedData[$config.keyField];
          if (keyId) $scope.Load(keyId);
        }
      };
      $config.searchFunc.func(args);
      return;
    }
    if (!$config.finder) return;
    if ($config.beforeSearch && !$config.beforeSearch($config.finder)) return;
    new $finder.ShowFinder({
      url: $config.finder.url,
      title: $config.finder.title,
      width: $config.finder.width,
      height: $config.finder.height,
      sortName: $config.finder.sortName,
      wildcardsearch: $config.finder.wildcardsearch,
      loadBySP: $config.finder.loadBySP,
      parameters: $config.finder.parameters,
      dataLoader: $config.finder.dataLoader,
      columns: $config.finder.columns,
      multiSelect: $config.finder.multiSelect,
      selectedIds: $config.finder.selectedIds,
      pageSize: $config.finder.pageSize,
      serverSide: $config.finder.serverSide,
      onSelect: function (selectedData) {
        if ($config.keyField && $config.keyField !== "") {
          var keyId = selectedData[$config.keyField];
          if (keyId) $scope.Load(keyId);
        }
      }
    });
  };

  $scope.Clear = function () {
    $scope.Model = {};
    if ($config.afterClear) $config.afterClear();
    $scope.$el.validationEngine("hide");
    $scope.Model.ModelState = ModelState.Unchanged;
  };

  $scope.Get = function (config) {
    if (!config || !config.url) return;
    if (!config.onError) config.onError = $utility.ErrorCallback;
    if (!config.data) config.data = {};
    config.data.ticks = new Date().valueOf();
    $http
      .get(config.url, {
        params: config.data
      })
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        if (config.onSuccess) config.onSuccess(res.data);
      }, config.onError);
  };

  $scope.Post = function (config) {
    if (!config || !config.url) return;
    if (!config.onError) config.onError = $utility.ErrorCallback;
    if (!config.data) config.data = {};
    var parameter = JSON.stringify(config.data);
    $http.post(config.url, parameter).then(function (res) {
      if ($utility.HasException(res.data)) return;
      if (config.onSuccess) config.onSuccess(res.data);
    }, config.onError);
  };
  //
  $scope.Init();
});
