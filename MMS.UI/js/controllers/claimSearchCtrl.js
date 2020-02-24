MicroInspireApp.controller("claimSearchCtrl", function(
  $scope,
  $http,
  $appConst,
  $utility,
  $state
) {
  $scope.$result = $("#resultTable");
  $scope.clear = function() {
    $scope.Model = {
      PartnerId: "-1",
      ProductId: "-1",
      BusinessId: "-1",
      ClaimStatus: ""
    };
    $scope.$result.bootstrapTable("load", []);
  };
  $scope.clear();
  $scope.partnerChanged = function() {
    if (!$scope.Model.PartnerId) {
      $scope.Products = [];
      return;
    }
    $http
      .get($appConst.ApiUrl + "/Combo/GetProducts/" + $scope.Model.PartnerId)
      .then(function(res) {
        if ($utility.HasException(res.data)) return;
        $scope.Products = res.data;
      }, $utility.ErrorCallback);
  };
  $scope.productChanged = function() {
    if (!$scope.Model.ProductId) {
      $scope.Business = [];
      return;
    }
    $http
      .get($appConst.ApiUrl + "/Combo/GetBusiness/" + $scope.Model.ProductId)
      .then(function(res) {
        if ($utility.HasException(res.data)) return;
        $scope.Business = res.data;
      }, $utility.ErrorCallback);
  };
  $scope.search = function() {
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/Search",
      data: JSON.stringify($scope.Model)
    }).then(function(res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.$result.bootstrapTable("load", res.data.Result);
    }, $utility.ErrorCallback);
  };
  $scope.claimDetails = function(claimId) {
    sessionStorage.setItem("ClaimId", claimId);
    $state.go("layout.claimdetails");
  };
  $scope.$result.bootstrapTable({
    height: 500,
    striped: true,
    pagination: true,
    pageSize: 10,
    pageList: [10, 50, 100],
    sidePagination: "client",
    showPaginationDetail: false,
    showColumns: false,
    showRefresh: false,
    search: false,
    clickToSelect: true,
    singleSelect: true,
    filterControl: true,
    columns: [
      { field: "ClaimId", visible: false },
      {
        field: "ClaimNumber",
        title: "Claim<br>Number",
        width: 150,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "PartnerName",
        title: "Partner<br>Name",
        width: 100,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "ProductName",
        title: "Product<br>Name",
        width: 150,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "ExternalId",
        title: "External<br>Id",
        width: 150,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "LineOfBusiness",
        title: "Line Of<br>Business",
        width: 120,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "InsuredFirstName",
        title: "First<br>Name",
        width: 150,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "InsuredLastName",
        title: "Last<br>Name",
        width: 100,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "DateOfIncident",
        title: "Date Of<br>Incident",
        width: 100,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "DateNotified",
        title: "Date<br>Notified",
        width: 100,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "ClaimStatus",
        title: "Claim<br>Status",
        width: 100,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "PolicyNumber",
        title: "Policy<br>Number",
        width: 100,
        sortable: true,
        filterControl: "input"
      }
    ],
    onClickRow: function(item, $element) {
      // $element
      //   .addClass("selectedRow")
      //   .siblings()
      //   .removeClass("selectedRow");
        $scope.claimDetails(item.ClaimId);
      return false;
    },
    onDblClickRow: function(row) {
      // $scope.claimDetails(row.ClaimId);
    }
  });
});
