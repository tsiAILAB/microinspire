MicroInspireApp.controller("importDataCtrl", function ($scope, $http,
  $appConst, $utility) {
  $scope.Model = { DataType: "Policy Enrolments" };
  $scope.partnerChanged = function () {
    if (!$scope.Model.PartnerId) {
      $scope.Products = [];
      return;
    }
    $http
      .get(
        $appConst.ApiUrl + "/Combo/GetProducts/" + $scope.Model.PartnerId
      )
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.Products = res.data;
        if ($scope.Products.length === 1) {
          $scope.Model.ProductId = $scope.Products[0].value;
        }
      }, $utility.ErrorCallback);
  };

  $("#fileUpload").CreateFileUploader({
    url: $appConst.ApiUrl + "/FileUpload/Upload",
    paramName: "uploadFile",
    allowedTypes: "xls,xlsx",
    multiple: false,
    util: $utility,
    onSuccess: function (files, file) {
      $scope.Model.FileName = file.FileName;
      $scope.Model.FilePath = file.FilePath;
      $scope.Model.OrgFileName = file.OrgFileName;
      $scope.Model.RootPath = file.RootPath;
      $scope.$apply();
    },
    onError: function (files, error) {
      var msg = $utility.ParseError(error.responseText);
      $utility.PrintMessageInFooter(msg);
    }
  });
  $scope.fileImport = function () {
    if (!$("input,select").smkValidate()) return;
  }
});
