MicroInspireApp.controller("policyCtrl", function (
  $scope,
  $http,
  $appConst,
  $utility,
  $state,
  $timeout
) {
  $scope.addClient = function () {
    $scope.Model.Clients.push({ Editing: true, Language: "Bengali", Communication: "SMS" });
  };
  $("#externalId").change(function () {
    var externalId = $(this).val();
    if (!externalId) {
      $scope.Model.IsUsedExternalId = undefined;
      return;
    }

    $http
      .get(
        $appConst.ApiUrl + "/Policy/UseExternal/" + externalId
      )
      .then(function (res) {
        if (res.data && res.data.ResponseCode && res.data.ResponseCode === "VALIDATION") {
          $scope.Model.IsUsedExternalId = true;
        }
        else if ($utility.HasException(res.data)) return;
        else
          $scope.Model.IsUsedExternalId = false;
      }, $utility.ErrorCallback);
  });
  $scope.save = function () {
    if (!$("input,select").smkValidate()) return;
    if ($scope.Model.IsUsedExternalId === true) return;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Policy/Create",
      data: JSON.stringify($scope.Model)
    }).then(function (res) {
      $utility.HideWait();
      if (res.data && res.data.ResponseCode && res.data.ResponseCode === "VALIDATION") {
        $scope.Model.IsUsedExternalId = true;
      }
      else if ($utility.HasException(res.data)) return;
      else {
        sessionStorage.setItem("PolicyId", res.data.Result.PolicyId);
        $state.go("layout.policydetails");
      }
    }, $utility.ErrorCallback);
  };
  $scope.clear = function () {
    $scope.Model = { Policy: {}, Asset: {} };
    $scope.Model.Clients = [
      {
        Title: "Primary Insured Details",
        ClientType: "Primary Insured",
        Relationship: "Unknown",
        Editing: true
      },
      { Editing: true }
    ];
    $("input,select").smkClear();
  };
  $timeout($scope.clear);
  $scope.partnerChanged = function () {
    if (!$scope.Model.Policy.PartnerId) {
      $scope.Products = [];
      return;
    }
    $http
      .get(
        $appConst.ApiUrl + "/Combo/GetProducts/" + $scope.Model.Policy.PartnerId
      )
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.Products = res.data;
        if ($scope.Products.length === 1) {
          $scope.Model.Policy.ProductId = $scope.Products[0].value;
          $scope.productChanged();
        }
      }, $utility.ErrorCallback);
  };
  $scope.productChanged = function () {
    if (!$scope.Model.Policy.ProductId) {
      $scope.Benefits = [];
      return;
    }
    $http
      .get(
        $appConst.ApiUrl + "/Combo/GetBenefitsByProduct/" + $scope.Model.Policy.ProductId
      )
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.Benefits = res.data;
        if ($scope.Benefits.length === 1)
          $scope.Model.Policy.BenefitId = $scope.Benefits[0].value;
        else $scope.Model.Policy.BenefitId = "";
        $scope.benefitChanged();
      }, $utility.ErrorCallback);
  };
  $scope.benefitChanged = function () {
    if (!$scope.Model.Policy.BenefitId) {
      $scope.Model.CoverageType = "";
      $scope.Model.DisableAssetType = false;
      return;
    }
    let selBenefit = $scope.Benefits.filter(b => b.value == $scope.Model.Policy.BenefitId);
    if (selBenefit.length) {
      if (!$scope.Model.Asset.AssetType && selBenefit[0].DefaultAssetType) {
        $scope.Model.Asset.AssetType = selBenefit[0].DefaultAssetType;
      }
      $scope.Model.CoverageType = selBenefit[0].CoverageType;
      $scope.Model.DisableAssetType = selBenefit[0].DisableAssetType;
    }
  };
  $scope.calculateCoverEndDate = function () {
    if (!$scope.Model.Policy.CoverStartDate || !$scope.Model.Policy.TermMonths)
      return;
    const startDate = $scope.Model.Policy.CoverStartDate.toDate(
      $appConst.SystemDateFormat
    );
    if (startDate == "Invalid Date") return;

    $scope.Model.Policy.CoverEndDate = startDate.addMonths(
      parseInt($scope.Model.Policy.TermMonths)
    );
  };
});
