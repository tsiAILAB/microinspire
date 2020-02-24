MicroInspireApp.controller("loginCtrl", function(
  $scope,
  $state,
  $authUser,
  $utility,
  $http,
  $appConst
) {
  $authUser.logOut();
  $scope.logIn = function() {
    setErrorMessage("");
    if (!$("#login-form").smkValidate() || !$scope.Email || !$scope.Password)
      return;
    // dummyLogin();
    // return;
    $utility.ShowWait();
    $http
      .post(
        $appConst.ApiUrl + "/User/SignIn",
        JSON.stringify({ Email: $scope.Email, Password: $scope.Password })
      )
      .then(
        function(res) {
          $utility.HideWait();
          const data = res.data;
          if (data.ResponseCode === "OK") {
            $authUser.setToken(data.Result.Token);
            delete data.Result.Token;
            $authUser.setUser(data.Result);
            $state.go("layout.home");
          } else setErrorMessage(data.Message);
        },
        function(error) {
          $utility.HideWait();
          if (error.status === -1) setErrorMessage("Server not found....");
          else if (error.data) setErrorMessage($utility.ParseError(error.data));
          else setErrorMessage("Internal server error....");
        }
      );
  };
  $scope.$watch("Email", function(newValue, oldValue) {
    if (newValue !== oldValue) {
      setErrorMessage("");
    }
  });
  $scope.$watch("Password", function(newValue, oldValue) {
    if (newValue !== oldValue) {
      setErrorMessage("");
    }
  });
  setErrorMessage = function(msg) {
    $scope.errorMesage = msg;
  };
  dummyLogin = function() {
    const user = {
      LogedId: 1,
      UserId: 1,
      Email: "ablmamuntue@yahoo.com",
      UserName: "Abdullah Al Mamun",
      UserType: "SuperAdmin",
      DateFormat: "dd/mm/yyyy"
    };
    const token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkFiZHVsbGFoIEFsIE1hbXVuIiwiTG9nZWRJZCI6IjQ3IiwiVXNlcklkIjoiMSIsIkVtYWlsIjoiYWJsbWFtdW50dWVAeWFob28uY29tIiwiVXNlclR5cGUiOiJTdXBlckFkbWluIiwiTG9nSW5EYXRlVGltZSI6IjE3LzAyLzIwMTkgMTY6MzA6MjciLCJJUEFkZHJlc3MiOiIxMjcuMC4wLjEiLCJuYmYiOjE1NTA0MjEwMzMsImV4cCI6MTU1ODE5NzAzMywiaWF0IjoxNTUwNDIxMDMzfQ.RHdxc2z4-MlW0o7Xze3amRLiZI5cN-IBaJ698m3pvIE";
    $authUser.setToken(token);
    $authUser.setUser(user);
    $state.go("layout.home");
  };
});
