MicroInspireApp.controller("profileCtrl", function (
  $rootScope,
  $scope,
  $http,
  $appConst,
  $utility,
  $timeout
) {
  getUser = function () {
    $utility.ShowWait();
    $http.get($appConst.ApiUrl + "/User/Get").then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      getPrivileges(res.data.Result);
    }, $utility.ErrorCallback);
  };
  getPrivileges = function (user) {
    $utility.ShowWait();
    $http.get($appConst.ApiUrl + "/User/GetUserPrivileges").then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model = res.data.Result;
      $scope.Model.User = user;
    }, $utility.ErrorCallback);
  };
  $scope.update = function () {
    if (!$("input").smkValidate()) return;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/User/UpdateProfile",
      data: JSON.stringify($scope.Model.User)
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $rootScope.currentUserName = `${$scope.Model.User.FirstName} ${$scope.Model.User.LastName}`;
      $utility.PrintMessageInHeader($appConst.UpdatedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  }
  $timeout(getUser);
});
