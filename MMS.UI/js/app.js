var MicroInspireApp = angular
  .module("microInspire", ["ui.router", "ui.select2"])
  .constant("$appConst", {
    ProjectTitle: "Micro Inspire",
    AppName: "Micro Inspire",
    NewIDString: "****<< NEW >>****",
    SavedSuccessfullyMsg: "Record saved successfully.",
    SaveErrorMsg: "Record could not be saved.",
    UpdatedSuccessfullyMsg: "Changes updated successfully.",
    DeletedSuccessfullyMsg: "Record deleted successfully.",
    DeletedErrorMsg: "Record could not be deleted.",
    ProcessSuccessfullyMsg: "Record process successfully.",
    IntMinValue: -2147483648,
    MinDateValue: "01/01/0001",
    SystemDateFormat: "dd/mm/yyyy",
    ServerDateFormat: "dd/mm/yyyy",
    BaseUrl: "http://localhost:5501",
    ApiUrl: "http://localhost:10050"
  });
