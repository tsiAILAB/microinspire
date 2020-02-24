MicroInspireApp.controller("userCtrl", function(
  $scope,
  $http,
  $appConst,
  $utility
) {
  $scope.clear = function() {
    $("input,select").smkClear();
    $scope.Model = {};
  };
  $("#email").change(function() {
    var email = $(this).val();
    if (!email || email === "ablmamuntue@yahoo.com") return;
    $http.get($appConst.ApiUrl + "/User/GetUser/" + email).then(function(res) {
      if ($utility.HasException(res.data)) return;
      $scope.Model = res.data.Result;
    }, $utility.ErrorCallback);
  });
  $scope.create = function() {
    if (!$("input,select").smkValidate()) return;
    if (!$.smkEqualPass("#password", "#confirmPassword")) return;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/User/SaveChanges",
      data: JSON.stringify($scope.Model)
    }).then(function(res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model = res.data.Result;
      $utility.PrintMessageInHeader($appConst.SavedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };
  $scope.clear();
});
