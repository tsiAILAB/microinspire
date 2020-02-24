MicroInspireApp.controller("layoutCtrl", function (
  $rootScope,
  $scope,
  $http,
  $utility,
  $appConst,
  $authUser,
  $timeout
) {
  const user = $authUser.getUser();
  if (user) {
    $rootScope.currentUserName = user.UserName;
    $rootScope.currentUserType = user.UserType;
    $appConst.SystemDateFormat = user.DateFormat.toLowerCase();
    $appConst.ServerDateFormat = user.DateFormat;
  }
  function GetBaseUrl() {
    const scripts = document.getElementsByTagName("script");
    let path = scripts[0].src.split("?")[0];
    path = path
      .split("/")
      .slice(0, -2)
      .join("/");
    return path;
  }

  $appConst.BaseUrl = GetBaseUrl();

  getInfo = function () {
    $utility.ShowWait();
    $http
      .get($appConst.ApiUrl + "/Policy/GetDashboard/")
      .then(function (res) {
        $utility.HideWait();
        if ($utility.HasException(res.data)) return;
        $scope.Model = res.data.Result;
      }, $utility.ErrorCallback);
  };
  $timeout(getInfo);
  $timeout(function () {
    if (ace && ace.demo) ace.demo.init();
  })
});
