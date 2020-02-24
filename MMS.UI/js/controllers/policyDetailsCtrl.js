MicroInspireApp.controller("policyDetailsCtrl", function(
  $scope,
  $http,
  $timeout,
  $state,
  $appConst,
  $utility
) {
  $scope.PolicyId = -1;
  if (sessionStorage.getItem("PolicyId")) {
    $scope.PolicyId = parseInt(sessionStorage.getItem("PolicyId"));
  }
  if ($scope.PolicyId === -1) return;
  getPolicy = function() {
    $utility.ShowWait();
    $http
      .get($appConst.ApiUrl + "/Policy/GetPolicy/" + $scope.PolicyId)
      .then(function(res) {
        $utility.HideWait();
        if ($utility.HasException(res.data)) return;
        $scope.Model = res.data.Result;
        console.log(JSON.stringify( $scope.Model));
        $("#claimTable").bootstrapTable("load", res.data.Result.Claims);
        $("#contributionTable").bootstrapTable("load", [
          {
            AssetType: "Loan",
            Amount: $scope.Model.Policy.LoanAmount,
            Date: $scope.Model.Policy.PolicyStart,
            Client: `${$scope.Model.Clients[0].FirstName} ${
              $scope.Model.Clients[0].LastName
            }`,
            CoverPeriod: `${$scope.Model.Policy.CoverStartDate} - ${
              $scope.Model.Policy.CoverEndDate
            }`
          }
        ]);
        $scope.ClientBackup = angular.copy($scope.Model.Clients);
        getBusiness();
      }, $utility.ErrorCallback);
  };
  $timeout(getPolicy);
  $scope.showEndDialog = function() {
    $("#policyEnd-modal").modal("show");
  };
  $scope.endPolicy = function() {
    if (!$("#policyEnd-modal").smkValidate()) return;
    let saveModel = {
      PolicyId: $scope.PolicyId,
      RequestedEndDate: $scope.Model.RequestedEndDate,
      EndReason: $scope.Model.EndReason,
      Note: { PolicyId: $scope.PolicyId, Note: $scope.Model.Note }
    };
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Policy/EndPolicy",
      data: JSON.stringify(saveModel)
    }).then(function(res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model.Policy.PolicyStatus = "Ended";
      $scope.Model.Policy.RequestedEndDate = res.data.Result.RequestedEndDate;
      $scope.Model.Policy.EndReason = res.data.Result.EndReason;
      $scope.Model.Policy.PolicyEnd = res.data.Result.PolicyEnd;
      for (let i = 0; i < $scope.Model.Clients.length; i++) {
        $scope.Model.Clients[i].Editable = false;
      }
      if (res.data.Result.Note.NoteId)
        $scope.Model.Notes.push(res.data.Result.Note);
        $scope.Model.Note = "";
      $("#policyEnd-modal").modal("hide");
    }, $utility.ErrorCallback);
  };
  $scope.addClient = function() {
    $scope.Model.Clients.push({
      Editable: true,
      Editing: true,
      PolicyId: $scope.PolicyId,
      ModelState: 1
    });
  };

  $scope.cancelClient = function ($client) {
    if (!$client.ClientId) {
      let index = $scope.Model.Clients.indexOf($client);
      if (index > -1) {
        $scope.Model.Clients.splice(index, 1);
      }
    } else {
      const client = $scope.ClientBackup.filter(
        p => p.ClientId === $client.ClientId
      );
      if (client.length) $client = Object.assign($client, client[0]);
      $client.Editing = false;
    }
  };

  $scope.updateClient = function($client, $eleId) {
    if (!$("#" + $eleId).smkValidate()) return;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Policy/SaveClient",
      data: JSON.stringify($client)
    }).then(function(res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $client.PCId = res.data.Result.PCId;
      $client.ClientId = res.data.Result.ClientId;
      $client.ClientCode = res.data.Result.ClientCode;
      $client.CreatedBy = res.data.Result.CreatedBy;
      $client.CreatedAt = res.data.Result.CreatedAt;
      $client.CreatedIP = res.data.Result.CreatedIP;
      $client.RowVersion = res.data.Result.RowVersion;
      $client.ModelState = res.data.Result.ModelState;

      const client = $scope.ClientBackup.filter(
        p => p.ClientId === $client.ClientId
      );
      if (client.length) client[0] = Object.assign(client[0], $client);
      else $scope.ClientBackup.push(angular.copy($client));

      $client.Editing = false;
      $utility.PrintMessageInHeader($appConst.SavedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.showNoteDialog = function() {
    $("#note-modal").modal("show");
  };
  $scope.addNote = function() {
    if ($scope.Model.Note) {
      $utility.ShowWait();
      $http({
        method: "POST",
        url: $appConst.ApiUrl + "/Policy/CreateNote",
        data: JSON.stringify({
          PolicyId: $scope.PolicyId,
          Note: $scope.Model.Note
        })
      }).then(function(res) {
        $utility.HideWait();
        if ($utility.HasException(res.data)) return;
        $scope.Model.Notes.push(res.data.Result);
        $scope.Model.Note = "";
        $("#note-modal").modal("hide");
      }, $utility.ErrorCallback);
    }
  };

  $scope.showClaimDialog = function() {
    $("#claim-modal").modal("show");
  };

  $scope.createClaim = function() {
    if (!$scope.Model.BusinessId || !$scope.Model.UnderWriterId) {
      return;
    }
    let claim = {
      PolicyId: $scope.Model.Policy.PolicyId,
      PartnerId: $scope.Model.Policy.PartnerId,
      ProductId: $scope.Model.Policy.ProductId,
      BusinessId: $scope.Model.BusinessId,
      UnderWriterId: $scope.Model.UnderWriterId,
      InsuredId: $scope.Model.Clients[0].ClientId,
      ModelState: 1
    };
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/Create",
      data: JSON.stringify(claim)
    }).then(function(res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $("#claim-modal").modal("hide");
      $timeout(function() {
        sessionStorage.setItem("ClaimId", res.data.Result.ClaimId);
        $state.go("layout.claimdetails");
      }, 1000);
    }, $utility.ErrorCallback);
  };

  getBusiness = function() {
    if (!$scope.Model.Policy.ProductId) {
      $scope.Business = [];
      return;
    }
    $http
      .get(
        $appConst.ApiUrl + "/Combo/GetBusiness/" + $scope.Model.Policy.ProductId
      )
      .then(function(res) {
        if ($utility.HasException(res.data)) return;
        $scope.Business = res.data;
      }, $utility.ErrorCallback);
  };

  $scope.businessChanged = function(business) {
    if (!$scope.Model.BusinessId) {
      $scope.Model.UnderWriterId = "";
      return;
    }
    let bus = business.filter(t => t.value === $scope.Model.BusinessId);
    if (bus.length) $scope.Model.UnderWriterId = bus[0].desc;
  };

  $("#claimTable").bootstrapTable({
    height: 180,
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
    columns: [
      { field: "ClaimId", visible: false },
      {
        field: "ClaimNumber",
        title: "Claim Number",
        width: 100
      },
      {
        field: "ClaimStatus",
        title: "Claim Status",
        width: 150
      },
      {
        field: "FirstName",
        title: "Insured First Name",
        width: 120
      },
      {
        field: "LastName",
        title: "Insured Last Name",
        width: 120
      },
      {
        field: "LineBusiness",
        title: "Line Of Business",
        width: 100,
      },
      {
        field: "DateOfIncident",
        title: "Date Of Incident",
        width: 100
      },
      {
        field: "DateNotified",
        title: "Date Notified",
        width: 100
      }
    ],
    onClickRow: function(item, $element) {
      // $element
      //   .addClass("selectedRow")
      //   .siblings()
      //   .removeClass("selectedRow");
      sessionStorage.setItem("ClaimId", item.ClaimId);
      $state.go("layout.claimdetails");
      return false;
    },
    onDblClickRow: function(row) {
      // sessionStorage.setItem("ClaimId", row.ClaimId);
      // $state.go("layout.claimdetails");
    }
  });

  $("#contributionTable").bootstrapTable({
    height: 180,
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
    columns: [
      {
        field: "AssetType",
        title: "Type",
        width: 150
      },
      {
        field: "Amount",
        title: "Amount",
        width: 100
      },
      {
        field: "Date",
        title: "Date",
        width: 100
      },
      {
        field: "Client",
        title: "Client",
        width: 150
      },
      {
        field: "CoverPeriod",
        title: "Cover Period",
        width: 150
      },
      {
        field: "ExternalRef",
        title: "External Ref",
        width: 100
      },
      {
        field: "ExternalType",
        title: "External Type",
        width: 100
      }
    ]
  });
});
