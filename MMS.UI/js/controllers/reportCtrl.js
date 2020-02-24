MicroInspireApp.controller("reportCtrl", function (
  $rootScope,
  $scope,
  $http,
  $utility,
  $appConst,
  $stateParams
) {
  $rootScope.ReportName = $stateParams.reportName;
  $scope.clear = function () {
    $scope.Model = {
      ProductId: "-1",
      BenefitId: "-1",
      NonInsured: "Yes",
      PaymentStatus: "All",
      ClaimStatus: "All",
      ClientCriteria: "All",
      CoverCriteria: "Cover Created - All",
      PaymentCriteria: "Payment Scheduled Date",
      PolicyCriteria: "All",
      PartnerCriteria: "All"
    };
  };
  $scope.countryChanged = function () {
    if (!$scope.Model.CountryId) {
      $scope.Partners = [];
      return;
    }
    $http
      .get($appConst.ApiUrl + "/Combo/GetPartners/" + $scope.Model.CountryId)
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.Partners = res.data;
        if ($scope.Partners.length === 1) {
          $scope.Model.PartnerId = $scope.Partners[0].value;
          $scope.partnerChanged();
        } else if ($scope.Partners.length > 1) {
          $scope.Model.PartnerId = "-1";
          $scope.Model.ProductId = "-1";
        }
      }, $utility.ErrorCallback);
  };
  $scope.partnerChanged = function () {
    if (!$scope.Model.PartnerId) {
      $scope.Products = [];
      return;
    }
    $http
      .get($appConst.ApiUrl + "/Combo/GetProducts/" + $scope.Model.PartnerId)
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.Products = res.data;
        if ($scope.Products.length === 1)
          $scope.Model.ProductId = $scope.Products[0].value;
        else if ($scope.Products.length > 1) $scope.Model.ProductId = "-1";
      }, $utility.ErrorCallback);
  };
  $scope.downloadClient = function () {
    if (!$scope.Model.ToDate) $scope.Model.ToDate = $scope.Model.FromDate;
    let fields = getHideFields();
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Report/InitParameter",
      data: JSON.stringify({
        ReportName: "Client",
        PartnerId: $scope.Model.PartnerId,
        ProductId: $scope.Model.ProductId,
        Criteria: $scope.Model.ClientCriteria,
        NonInsured: $scope.Model.NonInsured,
        FromDate: $scope.Model.FromDate,
        ToDate: $scope.Model.ToDate,
        Fields: fields
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      window.open($appConst.ApiUrl + "/Report/ShowClient/" + res.data.Result);
    }, $utility.ErrorCallback);
  };
  $scope.downloadPolicy = function () {
    if (!$scope.Model.ToDate) $scope.Model.ToDate = $scope.Model.FromDate;
    let fields = getHideFields();
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Report/InitParameter",
      data: JSON.stringify({
        ReportName: "Policy",
        PartnerId: $scope.Model.PartnerId,
        ProductId: $scope.Model.ProductId,
        Criteria: $scope.Model.PolicyCriteria,
        FromDate: $scope.Model.FromDate,
        ToDate: $scope.Model.ToDate,
        Fields: fields
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      window.open($appConst.ApiUrl + "/Report/ShowPolicy/" + res.data.Result);
    }, $utility.ErrorCallback);
  };
  $scope.downloadClaimDetails = function () {
    if (!$scope.Model.ToDate) $scope.Model.ToDate = $scope.Model.FromDate;
    let fields = getHideFields();
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Report/InitParameter",
      data: JSON.stringify({
        ReportName: "ClaimDetails",
        PartnerId: $scope.Model.PartnerId,
        ProductId: $scope.Model.ProductId,
        Status: $scope.Model.ClaimStatus,
        FromDate: $scope.Model.FromDate,
        ToDate: $scope.Model.ToDate,
        Fields: fields
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      window.open($appConst.ApiUrl + "/Report/ShowClaimDetails/" + res.data.Result);
    }, $utility.ErrorCallback);
  };
  $scope.downloadClaimPayment = function () {
    if (!$scope.Model.ToDate) $scope.Model.ToDate = $scope.Model.FromDate;
    let fields = getHideFields();
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Report/InitParameter",
      data: JSON.stringify({
        ReportName: "ClaimPayments",
        PartnerId: $scope.Model.PartnerId,
        ProductId: $scope.Model.ProductId,
        FromDate: $scope.Model.FromDate,
        ToDate: $scope.Model.ToDate,
        Fields: fields
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      window.open($appConst.ApiUrl + "/Report/ShowClaimPayments/" + res.data.Result);
    }, $utility.ErrorCallback);
  };
  $scope.downloadCWT = function () {
    let fields = getHideFields();
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Report/InitParameter",
      data: JSON.stringify({
        ReportName: "CWTReporting",
        PartnerId: $scope.Model.PartnerId,
        ProductId: $scope.Model.ProductId,
        Fields: fields
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      window.open($appConst.ApiUrl + "/Report/ShowCWT/" + res.data.Result);
    }, $utility.ErrorCallback);
  };
  $scope.downloadPartner = function () {
    if (!$scope.Model.ToDate) $scope.Model.ToDate = $scope.Model.FromDate;
    let fields = getHideFields();
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Report/InitParameter",
      data: JSON.stringify({
        ReportName: "Partner",
        PartnerId: $scope.Model.PartnerId,
        ProductId: $scope.Model.ProductId,
        BenefitId: $scope.Model.BenefitId,
        SalesReference: $scope.Model.SalesReference,
        Criteria: $scope.Model.PartnerCriteria,
        FromDate: $scope.Model.FromDate,
        ToDate: $scope.Model.ToDate,
        Fields: fields
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      window.open($appConst.ApiUrl + "/Report/ShowPartner/" + res.data.Result);
    }, $utility.ErrorCallback);
  };
  $scope.clear();
  getHideFields = function () {
    let fields = $scope.Fields.filter(f => !f.Checked);
    fields = [...new Set(fields.map(t => t.FieldName))];
    return fields;
  };
  getFields = function (spName) {
    $http
      .get($appConst.ApiUrl + "/Report/GetSpFields/" + spName)
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.Fields = res.data.Result;
        let maxrow = Math.ceil($scope.Fields.length / 4);
        $scope.fFields = $scope.Fields.slice(0 * 0, maxrow);
        $scope.sFields = $scope.Fields.slice(maxrow * 1, maxrow * 2);
        $scope.tFields = $scope.Fields.slice(maxrow * 2, maxrow * 3);
        $scope.ftFields = $scope.Fields.slice(maxrow * 3, maxrow * 4);
      }, $utility.ErrorCallback);
  };
  loadReportFields = function () {
    let spName = "RPTClient";
    switch ($rootScope.ReportName) {
      case "Client":
        spName = "RPTClient";
        break;
      case "Cover":
        spName = "RPTCover";
        break;
      case "Payment":
        spName = "RPTPayment";
        break;
      case "Policy":
        spName = "RPTPolicy";
        break;
      case "ClaimDetails":
        spName = "RPTClaimDetails";
        break;
      case "ClaimPayments":
        spName = "RPTClaimPayments";
        break;
      case "CWTReporting":
        spName = "RPTCWT";
        break;
      case "Partner":
        spName = "RPTPartner";
        break;
    }
    getFields(spName);
  };
  loadReportFields();
});
