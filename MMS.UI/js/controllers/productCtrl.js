MicroInspireApp.controller("productCtrl", function ($scope, $utility) {
  $scope.Model = {};
  $scope.save = function () {
    $.ajax({
      url: 'http://3.209.190.215:8081/api/quotes/GetRandomQuotes',
      type: 'GET',
      dataType: 'json',
      headers: {
        'Authorization': 'Basic dGhlaHVtYW5leHBlcmllbmNlMzEyOmNlYihIdW1hbil0aGUyMDE4'
      },
      contentType: 'application/json; charset=utf-8',
      success: function (result) {
        console.log("Result : ", result)
      },
      error: function (error) {
        console.log("Error : ", error)
      }
    });
  };
});
