MicroInspireApp.controller("claimCtrl", function (
  $scope,
  $http,
  $appConst,
  $utility,
  $state
) {
  $scope.save = function () {
    if (!$("input,select").smkValidate()) return;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/CreateClaim",
      data: JSON.stringify($scope.Model)
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      sessionStorage.setItem("ClaimId", res.data.Result.Claim.ClaimId);
      $state.go("layout.claimdetails");
    }, $utility.ErrorCallback);
  };
  $scope.clear = function () {
    $scope.Model = {
      Claim: {},
      Insured: { ClientType: "Primary Insured" },
      Notifier: { ClientType: "Notifier", Relationship: "Unknown" }
    };
    $("input,select").smkClear();
  };
  $scope.clear();
  $scope.partnerChanged = function (callback) {
    if (!$scope.Model.Claim.PartnerId) {
      $scope.Products = [];
      return;
    }
    $http
      .get($appConst.ApiUrl + "/Combo/GetProducts/" + $scope.Model.Claim.PartnerId)
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.Products = res.data;
        if (callback) callback();
        else {
          if ($scope.Products.length === 1) {
            $scope.Model.Claim.ProductId = $scope.Products[0].value;
            $scope.productChanged();
          }
        }
      }, $utility.ErrorCallback);
  };
  $scope.productChanged = function () {
    if (!$scope.Model.Claim.ProductId) {
      $scope.Business = [];
      return;
    }
    $http
      .get($appConst.ApiUrl + "/Combo/GetBusiness/" + $scope.Model.Claim.ProductId)
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.Business = res.data;
        if ($scope.Business.length === 1) {
          $scope.Model.Claim.BusinessId = $scope.Business[0].value;
          $scope.businessChanged($scope.Business);
        }
      }, $utility.ErrorCallback);
  };
  $scope.businessChanged = function (business) {
    if (!$scope.Model.Claim.BusinessId) {
      $scope.Model.Claim.UnderWriterId = "";
      return;
    }
    let bus = business.filter(t => t.value === $scope.Model.Claim.BusinessId);
    if (bus.length) $scope.Model.Claim.UnderWriterId = bus[0].desc;
  };
  $scope.searchPolicy = function () {
    if (!$scope.Model.Claim.ExternalId) {
      return;
    }
    $http
      .get(
        $appConst.ApiUrl + "/Policy/GetPolicyByExternal/" + $scope.Model.Claim.ExternalId
      )
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        let policy = res.data.Result;
        if (!policy.PolicyId) {
          $utility.ShowMessageBox("Information", "Policy not found.");
          return;
        }

        $scope.Model.Claim.PolicyId = policy.PolicyId;
        $scope.Model.Claim.PartnerId = policy.PartnerId;
        $scope.Model.Claim.InsuredId = policy.ClientId;

        $scope.Model.Insured.FirstName = policy.FirstName;
        $scope.Model.Insured.LastName = policy.LastName;
        $scope.Model.Insured.MobileNo = policy.MobileNo;
        $scope.Model.Insured.Gender = policy.Gender;
        $scope.Model.Insured.AgeAtCreationDate = policy.AgeAtCreationDate;
        $scope.Model.Insured.Relationship = policy.Relationship;
        $scope.partnerChanged(function () {
          $scope.Model.Claim.ProductId = policy.ProductId;
          $scope.productChanged();
        });
      }, $utility.ErrorCallback);
  };

  $scope.notifireChanged = function () {
    if (!$scope.Model.Notifier.NType) return;

    $http
      .get(
        $appConst.ApiUrl + "/Policy/GetNotifier/" + $scope.Model.Claim.PolicyId + "/" + $scope.Model.Notifier.NType
      )
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        let client = res.data.Result;
        if (!client.ClientId) return;

        $scope.Model.Claim.NotifierId = client.ClientId;

        $scope.Model.Notifier.FirstName = client.FirstName;
        $scope.Model.Notifier.LastName = client.LastName;
        $scope.Model.Notifier.MobileNo = client.MobileNo;
        $scope.Model.Notifier.AgeAtCreationDate = client.AgeAtCreationDate;
        $scope.Model.Notifier.Location = client.Location;
        $scope.Model.Notifier.Email = client.Email;
      }, $utility.ErrorCallback);
  };
});
