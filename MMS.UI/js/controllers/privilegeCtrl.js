MicroInspireApp.controller("privilegeCtrl", function(
  $scope,
  $http,
  $appConst,
  $utility
) {
  $("#email").change(function() {
    var email = $(this).val();
    if (!email || email === "ablmamuntue@yahoo.com") return;
    $http.get($appConst.ApiUrl + "/User/GetUser/" + email).then(function(res) {
      if ($utility.HasException(res.data)) return;
      $scope.Model.User = res.data.Result;
      getPrivileges();
    }, $utility.ErrorCallback);
  });
  getPrivileges = function() {
    if (!$scope.Model.User.UserId || $scope.Model.User.UserId === 0) {
      $scope.Privileges = {};
      return;
    }
    $utility.ShowWait();
    $http
      .get($appConst.ApiUrl + "/User/GetPrivileges/" + $scope.Model.User.UserId)
      .then(function(res) {
        $utility.HideWait();
        if ($utility.HasException(res.data)) return;
        $scope.Privileges = res.data.Result;
      }, $utility.ErrorCallback);
  };
  $scope.update = function() {
    if (!$("input").smkValidate()) return;
    let roles = $scope.Privileges.Roles.filter(r => r.Checked);
    let partners = $scope.Privileges.Partners.filter(p => p.Checked);
    const privileges = {
      UserId: $scope.Model.User.UserId,
      Roles: roles,
      Partners: partners
    };
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/User/SavePrivileges",
      data: JSON.stringify(privileges)
    }).then(function(res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $utility.PrintMessageInHeader($appConst.SavedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };
  $scope.clear = function() {
    $scope.Privileges = {};
    $scope.Model = {
      User: {}
    };
  };
});
