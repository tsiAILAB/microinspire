MicroInspireApp.controller("nirvoyClaimCtrl", function (
  $scope,
  $http,
  $appConst,
  $utility,
  $timeout
) {

  $("#mobileNumber").change(function () {
    var mobileNumber = $(this).val();
    if (!mobileNumber) return;
    $http
      .get(
        $appConst.ApiUrl + "/Nirvoy/GetNirvoyClient?mobileNumber=" + encodeURIComponent(mobileNumber)
      )
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        let client = res.data.Result;
        if (!client.ClientId) {
          $utility.ShowMessageBox("Information", "User not found.");
          return;
        }

        $scope.clear()        

        $scope.Model.Insured.FirstName = client.Name;
        $scope.Model.Insured.MobileNo = client.MobileNumber;
        $scope.Model.Insured.AgeAtCreationDate = client.Age;
        $scope.Model.Insured.PersonalIdType = client.PersonalIdType;
        $scope.Model.Insured.PersonalId = client.PersonalId;

        $scope.Model.Notifier.FirstName = client.BeneName;
        $scope.Model.Notifier.MobileNo = client.BeneMobileNumber;
        $scope.Model.Notifier.AgeAtCreationDate = client.BeneAge;
        $scope.Model.Notifier.Relationship = client.BeneRelationship;
      }, $utility.ErrorCallback);
  });

  $scope.create = function () {
    if (!$("input,select").smkValidate()) return;
    $scope.Model.Insured.Relationship = "Unknown";
    $scope.Model.Insured.ClientType = "Primary Insured";
    $scope.Model.Notifier.ClientType = "Beneficiary";
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/CreateClaim",
      data: JSON.stringify($scope.Model)
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $utility.PrintMessageInHeader("Claim added successfully.");
      $scope.clear();
    }, $utility.ErrorCallback);
  };

  $scope.clear = function () {
    $scope.Model = {
      Claim: {
        PartnerId: 1,
        ProductId: 2,
        BusinessId: 3,
        UnderWriterId: 2
      },
      Insured: {},
      Notifier: {}
    };    
  };
  $timeout($scope.clear);
});
