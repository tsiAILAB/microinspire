MicroInspireApp.controller("policySearchCtrl", function(
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
      PolicyStatus: ""
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
  $scope.search = function() {
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Policy/Search",
      data: JSON.stringify($scope.Model)
    }).then(function(res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.$result.bootstrapTable("load", res.data.Result);
    }, $utility.ErrorCallback);
  };
  $scope.policyDetails = function(policyId) {
    sessionStorage.setItem("PolicyId", policyId);
    $state.go("layout.policydetails");
  };
  $scope.$result.bootstrapTable({
    height: 500,
    striped: true,
    pagination: true,
    showExport: true,
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
      { field: "PolicyId", visible: false },
      {
        field: "PolicyNumber",
        title: "Policy<br>Number",
        width: 150,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "ExternalId",
        title: "External<br>Id",
        width: 100,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "FirstName",
        title: "First<br>Name",
        width: 150,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "LastName",
        title: "Last<br>Name",
        width: 150,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "MobileNo",
        title: "Mobile<br>No",
        width: 120,
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
        field: "PolicyStart",
        title: "Policy<br>Start Date",
        width: 100,
        sortable: true,
        filterControl: "input"
      },
      {
        field: "PolicyEnd",
        title: "Policy<br>End Date",
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
      $scope.policyDetails(item.PolicyId);
      return false;
    },
    onDblClickRow: function(row) {
      // $scope.policyDetails(row.PolicyId);
    }
  });
});
