MicroInspireApp.controller("claimDetailsCtrl", function (
  $scope,
  $http,
  $timeout,
  $utility,
  $appConst,
  $state
) {
  $scope.ApiUrl = $appConst.ApiUrl;
  $scope.ClaimId = -1;
  $scope.Util = {};
  if (sessionStorage.getItem("ClaimId")) {
    $scope.ClaimId = parseInt(sessionStorage.getItem("ClaimId"));
  }
  if ($scope.ClaimId === -1) return;
  $timeout(function () {
    $("a[data-toggle=tab]").click(function () {
      if ($(this).data("target") === "#history") {
        $utility.ShowWait();
        $http
          .get($appConst.ApiUrl + "/Claim/GetHistory/" + $scope.ClaimId)
          .then(function (res) {
            $utility.HideWait();
            if ($utility.HasException(res.data)) return;
            const clHis = res.data.Result.filter(
              h => h.HistoryType === "ClaimUpdate"
            );
            $("#claimHistoryTable").bootstrapTable("load", clHis);
            const stHis = res.data.Result.filter(
              h => h.HistoryType === "ClaimStatus"
            );
            $("#statusHistoryTable").bootstrapTable("load", stHis);
          }, $utility.ErrorCallback);
      }
    });
  });
  getClaim = function () {
    $utility.ShowWait();
    $http
      .get($appConst.ApiUrl + "/Claim/GetClaim/" + $scope.ClaimId)
      .then(function (res) {
        $utility.HideWait();
        if ($utility.HasException(res.data)) return;
        if (res.data.Result.Incident.CauseOfIncident)
          res.data.Result.Incident.CauseOfIncidents = res.data.Result.Incident.CauseOfIncident.split(
            ","
          );
        else res.data.Result.Incident.CauseOfIncidents = [];
        $scope.Model = res.data.Result;
        $scope.Model.Document = {};
        $scope.ModelBackup = angular.copy($scope.Model);
        delete $scope.ModelBackup.Document;
        delete $scope.ModelBackup.Documents;
        delete $scope.ModelBackup.Notes;
        delete $scope.ModelBackup.PayeeNames;
        delete $scope.ModelBackup.Formula;
        getBusiness();
        getDocTypes();
        getCauseOfIncidents();
      }, $utility.ErrorCallback);
  };

  getDocTypes = function () {
    if (!$scope.Model.Claim.ProductId) {
      $scope.docTypes = [];
      return;
    }
    $http
      .get(
        $appConst.ApiUrl + "/Combo/GetProductConfigurations/" + $scope.Model.Claim.ProductId + "/DocumentType"
      )
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.docTypes = res.data;
      }, $utility.ErrorCallback);
  };

  getCauseOfIncidents = function () {
    if (!$scope.Model.Claim.ProductId) {
      $scope.IncidentCauses = [];
      return;
    }
    $http
      .get(
        $appConst.ApiUrl + "/Combo/GetProductConfigurations/" + $scope.Model.Claim.ProductId + "/CauseOfIncident"
      )
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.IncidentCauses = res.data;
      }, $utility.ErrorCallback);
  };

  getBusiness = function () {
    if (!$scope.Model.Claim.ProductId) {
      $scope.Business = [];
      return;
    }
    $http
      .get(
        $appConst.ApiUrl + "/Combo/GetBusiness/" + $scope.Model.Claim.ProductId
      )
      .then(function (res) {
        if ($utility.HasException(res.data)) return;
        $scope.Business = res.data;
      }, $utility.ErrorCallback);
  };

  $scope.showNoteDialog = function () {
    $("#note-modal").modal("show");
  };

  $scope.addNote = function () {
    if ($scope.Model.Note) {
      $utility.ShowWait();
      $http({
        method: "POST",
        url: $appConst.ApiUrl + "/Claim/CreateNote",
        data: JSON.stringify({
          ClaimId: $scope.ClaimId,
          Note: $scope.Model.Note
        })
      }).then(function (res) {
        $utility.HideWait();
        if ($utility.HasException(res.data)) return;
        $scope.Model.Notes.push(res.data.Result);
        $scope.Model.Note = "";
        $("#note-modal").modal("hide");
      }, $utility.ErrorCallback);
    }
  };

  $("#error-modal").on("hidden.bs.modal", function () {
    $scope.Model.Claim.ClaimStatus = $scope.ModelBackup.Claim.ClaimStatus;
    $scope.$apply();
  });

  $("#status-modal").on("hidden.bs.modal", function () {
    if (!$scope.StatusUpdated)
      $scope.Model.Claim.ClaimStatus = $scope.ModelBackup.Claim.ClaimStatus;
    $scope.StatusUpdated = false;
    $scope.$apply();
  });

  $scope.showStatusDialog = function () {
    if (!isValid()) {
      $("#error-modal").modal("show");
      return;
    }
    $("#status-modal").modal("show");
  };

  isValid = function () {
    $scope.statusNodePlaceholder = "Enter status note";
    if ($scope.Model.Claim.ClaimStatus === "Documents Incomplete" && $scope.ModelBackup.Claim.ClaimStatus === "Closed")
      $scope.statusNodePlaceholder = "Mandatory: A note must be entered before proceeding.";
    $scope.mandatoryMesage = [];
    if ($scope.Model.Claim.ClaimStatus === "Documents Incomplete") {
      if (
        $scope.ModelBackup.Claim.DateNotified &&
        $scope.ModelBackup.Claim.DateOfIncident
      ) {
        const notiDate = $scope.ModelBackup.Claim.DateNotified.toDate(
          $appConst.SystemDateFormat
        );
        const incDate = $scope.ModelBackup.Claim.DateOfIncident.toDate(
          $appConst.SystemDateFormat
        );
        if (notiDate != "Invalid Date" && incDate != "Invalid Date") {
          if (notiDate < incDate)
            $scope.mandatoryMesage.push(
              "Date Of Incident cannot be greater than Date Of Notification."
            );
        }
      }
      if (!$scope.ModelBackup.Notifier.FirstName)
        $scope.mandatoryMesage.push(
          "Notifier First Name must be completed before proceeding."
        );
      if (!$scope.ModelBackup.Claim.DateNotified)
        $scope.mandatoryMesage.push(
          "Date Notified must be completed before proceeding."
        );
      if (
        !$scope.ModelBackup.Notifier.MobileNo &&
        !$scope.ModelBackup.Notifier.Email
      )
        $scope.mandatoryMesage.push(
          "Notifier Contact Number or Email must be completed before proceeding."
        );
    } else if ($scope.Model.Claim.ClaimStatus === "Awaiting Claim Validation") {
      if (!$scope.ModelBackup.Claim.DateOfIncident)
        $scope.mandatoryMesage.push(
          "Date Of Incident must be completed before proceeding."
        );
      if (!$scope.ModelBackup.Incident.DateOfDeath)
        if ($scope.Model.Claim.BusinessName === 'Asset')
          $scope.mandatoryMesage.push(
            "Date Of Incident must be completed before proceeding."
          );
        else
          $scope.mandatoryMesage.push(
            "Date Of Death must be completed before proceeding."
          );
      if (!$scope.ModelBackup.Incident.IncidentType)
        $scope.mandatoryMesage.push(
          "Incident Type Number must be completed before proceeding."
        );
      if (
        !$scope.ModelBackup.Incident.CauseOfIncidents ||
        !$scope.ModelBackup.Incident.CauseOfIncidents.length
      )
        $scope.mandatoryMesage.push(
          "Cause Of Incident Number must be completed before proceeding."
        );
    } else if ($scope.Model.Claim.ClaimStatus === "Awaiting UW Decision") {
      if ($scope.ModelBackup.Claim.Decision !== "Approved")
        $scope.mandatoryMesage.push(
          "Claim Review Decision must be Approved before proceeding."
        );
    } else if ($scope.Model.Claim.ClaimStatus === "Awaiting Payment") {
      if (
        $scope.ModelBackup.Claim.UWReviewRequired &&
        $scope.ModelBackup.Claim.UWDecision !== "Approved"
      )
        $scope.mandatoryMesage.push(
          "Underwriter Review Decision must be Approved before proceeding."
        );
    } else if (
      $scope.ModelBackup.Claim.ClaimStatus === "Awaiting Payment" &&
      $scope.Model.Claim.ClaimStatus === "Closed"
    ) {
      for (let i = 0; i < $scope.ModelBackup.Payments.length; i++) {
        if (!$scope.ModelBackup.Payments[i].IssuedDate)
          $scope.mandatoryMesage.push(
            `${
            $scope.ModelBackup.Payments[i].PaymentMethod
            } : Payment Issued Date must be completed before proceeding.`
          );
        if (!$scope.ModelBackup.Payments[i].IssuedBy)
          $scope.mandatoryMesage.push(
            `${
            $scope.ModelBackup.Payments[i].PaymentMethod
            } : Payment Issued By must be completed before proceeding.`
          );
      }
      if ($scope.ModelBackup.Claim.Pay === "Approved")
        $scope.mandatoryMesage.push(
          "Claim payment details must be Approved before proceeding."
        );
    }

    return !$scope.mandatoryMesage.length;
  };

  $scope.updateStatus = function () {
    if ($scope.Model.Claim.ClaimStatus === "Documents Incomplete"
      && $scope.ModelBackup.Claim.ClaimStatus === "Closed" && !$scope.Model.Note) {
      return;
    }
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/UpdateStatus",
      data: JSON.stringify({
        ClaimId: $scope.ClaimId,
        ClaimStatus: $scope.Model.Claim.ClaimStatus,
        ClosureReason: $scope.Model.Claim.ClosureReason,
        Note: { ClaimId: $scope.ClaimId, Note: $scope.Model.Note }
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      if (res.data.Result && res.data.Result.Note.NoteId)
        $scope.Model.Notes.push(res.data.Result.Note);
      if ($scope.Model.Claim.ClosureReason) {
        $scope.Model.Claim.ClosureDate = res.data.Result.ClosureDate;
        $scope.ModelBackup.Claim.ClosureReason =
          $scope.Model.Claim.ClosureReason;
        $scope.ModelBackup.Claim.ClosureDate = $scope.Model.Claim.ClosureDate;
      }
      $scope.ModelBackup.Claim.ClaimStatus = $scope.Model.Claim.ClaimStatus;
      $scope.Model.Note = "";
      $scope.StatusUpdated = true;
      $("#status-modal").modal("hide");
    }, $utility.ErrorCallback);
  };

  $scope.birthDateChanged = function () {
    $scope.Model.Insured.AgeAtCreationDate = $utility.GetAge(
      $scope.Model.Insured.DateofBirth
    );
  };

  $timeout(getClaim);

  $("#documentUpload").CreateFileUploader({
    url: $appConst.ApiUrl + "/FileUpload/Upload",
    paramName: "uploadFile",
    allowedTypes: "jpg,jpeg,png,gif,pdf",
    multiple: false,
    util: $utility,
    onSuccess: function (files, file) {
      $scope.Model.Document.FileName = file.FileName;
      $scope.Model.Document.FilePath = file.FilePath;
      $scope.Model.Document.OrgFileName = file.OrgFileName;
      $scope.Model.Document.RootPath = file.RootPath;
      $scope.$apply();
    },
    onError: function (files, error) {
      var msg = $utility.ParseError(error.responseText);
      $utility.PrintMessageInFooter(msg);
    }
  });

  $scope.cancelInsured = function () {
    $scope.Model.Insured = angular.copy($scope.ModelBackup.Insured);
    $scope.Model.Util.InsuredEditing = false;
  };

  $scope.updateInsured = function () {
    if (!$("#insuredCli").smkValidate()) return;
    $scope.Model.Insured.ClaimId = $scope.ClaimId;
    if (!$scope.Model.Insured.ClientType)
      $scope.Model.Insured.ClientType = "Primary Insured";
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/CreateClient",
      data: JSON.stringify($scope.Model.Insured)
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model.Insured = res.data.Result;
      $scope.Model.Claim.InsuredId = res.data.Result.ClientId;
      $scope.Model.Util.InsuredEditing = false;
      $scope.ModelBackup.Insured = angular.copy($scope.Model.Insured);
      $scope.ModelBackup.Claim.InsuredId = res.data.Result.ClientId;
      $utility.PrintMessageInHeader($appConst.SavedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.cancelNotifire = function () {
    $scope.Model.Notifier = angular.copy($scope.ModelBackup.Notifier);
    $scope.Model.Claim.DateNotified = $scope.ModelBackup.Claim.DateNotified;
    $scope.Model.Util.NotifireEditing = false;
  };

  $scope.updateNotifier = function () {
    if (!$("#notiDetails").smkValidate()) return;
    $scope.Model.Notifier.ClaimId = $scope.ClaimId;
    $scope.Model.Notifier.DateNotified = $scope.Model.Claim.DateNotified;
    if (!$scope.Model.Notifier.ClientType)
      $scope.Model.Notifier.ClientType = "Notifier";
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/CreateClient",
      data: JSON.stringify($scope.Model.Notifier)
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model.Notifier = res.data.Result;
      $scope.Model.Claim.NotifierId = res.data.Result.ClientId;
      $scope.Model.Util.NotifireEditing = false;
      $scope.ModelBackup.Notifier = angular.copy($scope.Model.Notifier);
      $scope.ModelBackup.Claim.NotifierId = res.data.Result.ClientId;
      $scope.ModelBackup.Claim.DateNotified = $scope.Model.Claim.DateNotified;
      $utility.PrintMessageInHeader($appConst.SavedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.cancelCover = function () {
    $scope.Model.Claim = angular.copy($scope.ModelBackup.Claim);
    $scope.Model.Util.CoverEditing = false;
  };

  $scope.updateCover = function () {
    if (!$("#coverDet").smkValidate()) return;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/UpdateCover",
      data: JSON.stringify({
        ClaimId: $scope.ClaimId,
        BusinessId: $scope.Model.Claim.BusinessId,
        DateOfIncident: $scope.Model.Claim.DateOfIncident,
        CoverStartDate: $scope.Model.Claim.CoverStartDate,
        CoverEndDate: $scope.Model.Claim.CoverEndDate,
        CoverAmount: $scope.Model.Claim.CoverAmount,
        RevisedCoverAmount: $scope.Model.Claim.RevisedCoverAmount
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model.Util.CoverEditing = false;
      $scope.ModelBackup.Claim = angular.copy($scope.Model.Claim);
      $utility.PrintMessageInHeader($appConst.UpdatedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.cancelIncident = function () {
    $scope.Model.Incident = angular.copy($scope.ModelBackup.Incident);
    $scope.Model.Util.IncidentEditing = false;
  };

  $scope.updateIncident = function () {
    if (!$("#lineBuDet").smkValidate()) return;
    if (!$scope.Model.Incident.ClaimId)
      $scope.Model.Incident.ClaimId = $scope.ClaimId;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/CreateIncident",
      data: JSON.stringify($scope.Model.Incident)
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model.Incident = res.data.Result;
      $scope.Model.Util.IncidentEditing = false;
      $scope.ModelBackup.Incident = angular.copy($scope.Model.Incident);
      $utility.PrintMessageInHeader($appConst.SavedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.cancelClaimReview = function () {
    $scope.Model.Claim = angular.copy($scope.ModelBackup.Claim);
    $scope.Model.Util.ReviewEditing = false;
  };

  $scope.decisionChange = function () {
    if ($scope.Model.Claim.Decision === "Rejected")
      $scope.Model.Claim.ApprovedAmount = 0;
  };

  $scope.updateClaimReview = function () {
    if (!$("#claimReview").smkValidate()) return;
    if (
      $scope.Model.Claim.ClaimStatus === "Registered" ||
      $scope.Model.Claim.ClaimStatus === "Documents Incomplete"
    ) {
      $utility.ShowMessageBox(
        "Claim Review",
        "Claim Status must be Awaiting Claim Validation before confirming."
      );
      return;
    }
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/UpdateClaimReview",
      data: JSON.stringify({
        ClaimId: $scope.ClaimId,
        UWReviewRequired: $scope.Model.Claim.UWReviewRequired,
        ApprovedAmount: $scope.Model.Claim.ApprovedAmount,
        Decision: $scope.Model.Claim.Decision,
        RejectionReason: $scope.Model.Claim.RejectionReason
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model.Claim = res.data.Result;
      $scope.Model.Util.ReviewEditing = false;
      $scope.ModelBackup.Claim = angular.copy($scope.Model.Claim);
      $utility.PrintMessageInHeader($appConst.UpdatedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.cancelUW = function () {
    $scope.Model.Claim.UWSentDate = $scope.ModelBackup.Claim.UWSentDate;
    $scope.Model.Claim.UWExternalRef = $scope.ModelBackup.Claim.UWExternalRef;
    $scope.Model.Claim.UWStatus = $scope.ModelBackup.Claim.UWStatus;
    $scope.Model.Util.UWEditing = false;
  };

  $scope.updateUW = function () {
    if (!$("#uwReview").smkValidate()) return;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/UpdateUW",
      data: JSON.stringify({
        ClaimId: $scope.ClaimId,
        UWSentDate: $scope.Model.Claim.UWSentDate,
        UWExternalRef: $scope.Model.Claim.UWExternalRef,
        UWStatus: $scope.Model.Claim.UWStatus
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model.Util.UWEditing = false;
      $scope.ModelBackup.Claim.UWSentDate = $scope.Model.Claim.UWSentDate;
      $scope.ModelBackup.Claim.UWExternalRef = $scope.Model.Claim.UWExternalRef;
      $scope.ModelBackup.Claim.UWStatus = $scope.Model.Claim.UWStatus;
      $utility.PrintMessageInHeader($appConst.UpdatedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.cancelUWA = function () {
    $scope.Model.Claim = angular.copy($scope.ModelBackup.Claim);
    $scope.Model.Util.UWAEditing = false;
  };

  $scope.uwDecisionChange = function () {
    if ($scope.Model.Claim.UWDecision === "Rejected")
      $scope.Model.Claim.UWApprovedAmount = 0;
  };

  $scope.updateUWA = function () {
    if (!$("#uwAdvice").smkValidate()) return;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/UpdateUWA",
      data: JSON.stringify({
        ClaimId: $scope.ClaimId,
        UWAdviceDate: $scope.Model.Claim.UWAdviceDate,
        UWAdviceFrom: $scope.Model.Claim.UWAdviceFrom,
        UWAdviceRef: $scope.Model.Claim.UWAdviceRef,
        UWApprovedAmount: $scope.Model.Claim.UWApprovedAmount,
        UWDecision: $scope.Model.Claim.UWDecision,
        UWRejectionReason: $scope.Model.Claim.UWRejectionReason
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model.Claim = res.data.Result;
      $scope.Model.Util.UWAEditing = false;
      $scope.ModelBackup.Claim = angular.copy($scope.Model.Claim);
      $utility.PrintMessageInHeader($appConst.UpdatedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.setReminder = function () {
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/SetReminder",
      data: JSON.stringify({
        ClaimId: $scope.ClaimId,
        ReminderDueDate: $scope.Model.Claim.ReminderDueDate,
        ReminderComment: $scope.Model.Claim.ReminderComment
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.ModelBackup.Claim.ReminderDueDate =
        $scope.Model.Claim.ReminderDueDate;
      $scope.ModelBackup.Claim.ReminderComment =
        $scope.Model.Claim.ReminderComment;
      $utility.PrintMessageInHeader($appConst.UpdatedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.updateDocumentComplete = function () {
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/DocumentComplete",
      data: JSON.stringify({
        ClaimId: $scope.ClaimId,
        DocumentCompleteDate: $scope.Model.Claim.DocumentCompleteDate
      })
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model.Util.DocEditing = false;
      $scope.ModelBackup.Claim.DocumentCompleteDate =
        $scope.Model.Claim.DocumentCompleteDate;
      $utility.PrintMessageInHeader($appConst.UpdatedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.addDocument = function () {
    $utility.ShowWait();
    $scope.Model.Document.ClaimId = $scope.ClaimId;
    $scope.Model.Document.ClaimNumber = $scope.Model.Claim.ClaimNumber;
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/CreateDocument",
      data: JSON.stringify($scope.Model.Document)
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $scope.Model.Document = {};
      $scope.Model.Documents.push(res.data.Result);
      $utility.PrintMessageInHeader($appConst.SavedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.dateOfDeathChanged = function () {
    let days = 0;
    if (
      $scope.Model.Claim.DateOfIncident &&
      $scope.Model.Incident.DateOfDeath
    ) {
      const inciDate = $scope.Model.Claim.DateOfIncident.toDate(
        $appConst.SystemDateFormat
      );
      const deathDate = $scope.Model.Incident.DateOfDeath.toDate(
        $appConst.SystemDateFormat
      );
      days = datediff(inciDate, deathDate, "days");
      if (isNaN(days) || parseInt(days) < 0) days = 0;
    }
    $scope.Model.Incident.DaysFromIncident = days;
  };

  $scope.dateOfIncidentChanged = function () {
    if (
      !$scope.Model.Claim.DateOfIncident ||
      !$scope.Model.Claim.CoverStartDatePO ||
      !$scope.Model.Claim.CoverEndDatePO
    )
      return;
    const inciDate = $scope.Model.Claim.DateOfIncident.toDate(
      $appConst.SystemDateFormat
    );
    const startDate = $scope.Model.Claim.CoverStartDatePO.toDate(
      $appConst.SystemDateFormat
    );
    const endDate = $scope.Model.Claim.CoverEndDatePO.toDate(
      $appConst.SystemDateFormat
    );
    if (inciDate >= startDate && inciDate <= endDate) {
      $scope.Model.Claim.CoverStartDate = startDate;
      $scope.Model.Claim.CoverEndDate = endDate;
      if (!$scope.Model.Formula.length) return;
      if ($scope.Model.Claim.BusinessId == 1) {
        $scope.Model.Claim.CoverAmount = RoundNumber(
          (parseFloat($scope.Model.Claim.LoanAmount) / 100) * 80,
          0
        );
      } else if ($scope.Model.Claim.BusinessId == 2) {
        const perMonth = parseFloat($scope.Model.Claim.LoanAmount) / 12;
        let months = datediff(startDate, inciDate, "months");
        if (isNaN(months) || parseInt(months) < 0) months = 0;
        months = 12 - months;
        $scope.Model.Claim.CoverAmount = RoundNumber(perMonth * perMonth, 0);
      } else if ($scope.Model.Claim.BusinessId == 3) {
        const cover = $scope.Model.Formula.filter(
          f =>
            $scope.Model.Claim.LoanAmount >= f.FromAmount &&
            $scope.Model.Claim.LoanAmount <= f.ToAmount
        );
        if (cover.length) {
          $scope.Model.Claim.CoverAmount = cover[0].CoverAmount;
        }
      }

    } else {
      $scope.Model.Claim.CoverStartDate = null;
      $scope.Model.Claim.CoverEndDate = null;
      $scope.Model.Claim.CoverAmount = null;
    }
  };

  $scope.addPayment = function () {
    const method = $scope.Model.Claim.PaymentMethod;
    $scope.Model.Claim.PaymentMethod = "";
    const payment = $scope.Model.Payments.filter(
      p => p.PaymentMethod === method
    );
    if (payment.length) return;
    $scope.Model.Payments.push({
      ClaimId: $scope.ClaimId,
      PaymentMethod: method,
      Editing: true,
      ModelState: 1
    });
  };

  $scope.cancelPayment = function ($payment) {
    if (!$payment.PaymentId) {
      let index = $scope.Model.Payments.indexOf($payment);
      if (index > -1) {
        $scope.Model.Payments.splice(index, 1);
      }
    } else {
      const payment = $scope.ModelBackup.Payments.filter(
        p => p.PaymentId === $payment.PaymentId
      );
      if (payment.length) $payment = Object.assign($payment, payment[0]);
      $payment.Editing = false;
    }
  };

  $scope.updatePayment = function ($payment, $eleId) {
    if (!$("#" + $eleId).smkValidate()) return;
    if (!$payment.Amount) return;
    $utility.ShowWait();
    $http({
      method: "POST",
      url: $appConst.ApiUrl + "/Claim/CreatePayment",
      data: JSON.stringify($payment)
    }).then(function (res) {
      $utility.HideWait();
      if ($utility.HasException(res.data)) return;
      $payment.PaymentId = res.data.Result.PaymentId;
      $payment.ClientCode = res.data.Result.ClientCode;
      $payment.CreatedBy = res.data.Result.CreatedBy;
      $payment.CreatedAt = res.data.Result.CreatedAt;
      $payment.CreatedIP = res.data.Result.CreatedIP;
      $payment.RowVersion = res.data.Result.RowVersion;
      $payment.ModelState = res.data.Result.ModelState;
      const payment = $scope.ModelBackup.Payments.filter(
        p => p.PaymentId === $payment.PaymentId
      );
      if (payment.length) payment[0] = Object.assign(payment[0], $payment);
      else $scope.ModelBackup.Payments.push(angular.copy($payment));
      $payment.Editing = false;
      $utility.PrintMessageInHeader($appConst.SavedSuccessfullyMsg);
    }, $utility.ErrorCallback);
  };

  $scope.policyDetails = function (policyId) {
    sessionStorage.setItem("PolicyId", policyId);
    $state.go("layout.policydetails");
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

        $scope.Model.Notifier.ClientId = client.ClientId;
        $scope.Model.Notifier.FirstName = client.FirstName;
        $scope.Model.Notifier.LastName = client.LastName;
        $scope.Model.Notifier.MobileNo = client.MobileNo;
        $scope.Model.Notifier.AgeAtCreationDate = client.AgeAtCreationDate;
        $scope.Model.Notifier.Location = client.Location;
        $scope.Model.Notifier.Email = client.Email;
        $scope.Model.Notifier.Relationship = client.Relationship;
      }, $utility.ErrorCallback);
  };

  $("#claimHistoryTable").bootstrapTable({
    height: 360,
    striped: true,
    pagination: true,
    pageSize: 10,
    sidePagination: "client",
    showPaginationDetail: false,
    showColumns: false,
    showRefresh: false,
    search: false,
    clickToSelect: true,
    singleSelect: true,
    columns: [
      {
        field: "HistoryId",
        visible: false
      },
      {
        field: "Description",
        title: "Claim Data Added Or Changed",
        width: 200
      },
      {
        field: "CreatedAt",
        title: "Date",
        width: 100
      },
      {
        field: "CreatedByName",
        title: "User",
        width: 150
      }
    ]
  });
  $("#statusHistoryTable").bootstrapTable({
    height: 360,
    striped: true,
    pagination: true,
    pageSize: 10,
    sidePagination: "client",
    showPaginationDetail: false,
    showColumns: false,
    showRefresh: false,
    search: false,
    clickToSelect: true,
    singleSelect: true,
    columns: [
      {
        field: "HistoryId",
        visible: false
      },
      {
        field: "Description",
        title: "Claim Status Set",
        width: 200
      },
      {
        field: "CreatedAt",
        title: "Date",
        width: 100
      },
      {
        field: "CreatedByName",
        title: "User",
        width: 150
      }
    ]
  });
});
