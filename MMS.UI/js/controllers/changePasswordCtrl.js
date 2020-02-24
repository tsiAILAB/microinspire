MicroInspireApp.controller("changePasswordCtrl", function(
  $scope,
  $http,
  $appConst,
  $utility
) {
  $scope.clear = function() {
    $("input,select").smkClear();
    $scope.Model = {};
  };
  $scope.changePassword = function() {
    if (!$("input,select").smkValidate()) return;
    if (!$.smkEqualPass("#password", "#confirmPassword")) return;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/User/ChangePassword",
      data: JSON.stringify($scope.Model)
    }).then(function(res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.clear();
      $utility.PrintMessageInHeader($appConst.UpdatedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };
  $scope.clear();
});
