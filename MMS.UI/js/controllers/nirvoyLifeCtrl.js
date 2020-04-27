MicroInspireApp.controller("nirvoyLifeCtrl", function (
  $scope,
  $http,
  $appConst,
  $utility,
  $timeout
) {
  $scope.save = function () {
    if (!$("input,select").smkValidate()) return;    
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Nirvoy/Enroll",
      data: JSON.stringify($scope.Model)
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.clear();
    }, $utility.ErrorCallback);
  };
  $scope.clear = function () {
    $scope.Model = {};
    $("input,select").smkClear();
  };
  $timeout($scope.clear);
});
