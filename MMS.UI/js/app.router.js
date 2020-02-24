MicroInspireApp.config(function ($stateProvider) {
  $stateProvider
    .state("login", {
      url: "/",
      templateUrl: "pages/login.html",
      controller: "loginCtrl",
      cache: false
    })
    .state("layout", {
      url: "",
      abstract: true,
      templateUrl: "pages/layout.html",
      controller: "layoutCtrl",
      cache: false
    })
    .state("layout.home", {
      url: "/home",
      templateUrl: "pages/home.html",
      cache: false
    })
    .state("layout.partner", {
      url: "/partner",
      templateUrl: "pages/partner.html",
      controller: "partnerCtrl",
      cache: false
    })
    .state("layout.product", {
      url: "/product",
      templateUrl: "pages/product.html",
      controller: "productCtrl",
      cache: false
    })
    .state("layout.configure", {
      url: "/configure",
      templateUrl: "pages/configure.html",
      controller: "configureCtrl",
      cache: false
    })
    .state("layout.policy", {
      url: "/policy",
      templateUrl: "pages/policy.html",
      controller: "policyCtrl",
      cache: false
    })
    .state("layout.policydetails", {
      url: "/policydetails",
      templateUrl: "pages/policyDetails.html",
      controller: "policyDetailsCtrl",
      cache: false
    })
    .state("layout.policysearch", {
      url: "/policysearch",
      templateUrl: "pages/policySearch.html",
      controller: "policySearchCtrl",
      cache: false
    })
    .state("layout.claim", {
      url: "/claim",
      templateUrl: "pages/claim.html",
      controller: "claimCtrl",
      cache: false
    })
    .state("layout.claimdetails", {
      url: "/claimdetails",
      templateUrl: "pages/claimDetails.html",
      controller: "claimDetailsCtrl",
      cache: false
    })
    .state("layout.claimsearch", {
      url: "/claimsearch",
      templateUrl: "pages/claimSearch.html",
      controller: "claimSearchCtrl",
      cache: false
    })
    .state("layout.dashboard", {
      url: "/dashboard",
      templateUrl: "pages/dashboard.html",
      controller: "dashboardCtrl",
      cache: false
    })
    .state("layout.importdata", {
      url: "/importdata",
      templateUrl: "pages/importData.html",
      controller: "importDataCtrl",
      cache: false
    })
    .state("layout.user", {
      url: "/user",
      templateUrl: "pages/user.html",
      controller: "userCtrl",
      cache: false
    })
    .state("layout.privilege", {
      url: "/privilege",
      templateUrl: "pages/privilege.html",
      controller: "privilegeCtrl",
      cache: false
    })
    .state("layout.profile", {
      url: "/profile",
      templateUrl: "pages/profile.html",
      controller: "profileCtrl",
      cache: false
    })
    .state("layout.changepassword", {
      url: "/changepassword",
      templateUrl: "pages/changePassword.html",
      controller: "changePasswordCtrl",
      cache: false
    })
    .state("layout.report", {
      url: "/report",
      templateUrl: "pages/report.html",
      controller: "reportCtrl",
      params: { reportName: "Client" },
      cache: false
    })
    .state("layout.nirvoyenroll", {
      url: "/nirvoyenroll",
      templateUrl: "pages/nirvoyEnroll.html",
      controller: "nirvoyEnrollCtrl",
      cache: false
    })
    .state("layout.nirvoyclaim", {
      url: "/nirvoyclaim",
      templateUrl: "pages/nirvoyClaim.html",
      controller: "nirvoyClaimCtrl",
      cache: false
    })
    .state("layout.notfound", {
      url: "/notfound",
      templateUrl: "pages/error404.html",
      cache: false
    })
    .state("layout.internal", {
      url: "/internal",
      templateUrl: "pages/error500.html",
      cache: false
    });
});
MicroInspireApp.run([
  "$rootScope",
  "$location",
  "$state",
  "$timeout",
  "$authUser",
  "$utility",
  function ($rootScope, $location, $state, $timeout, $authUser, $utility) {
    $rootScope.$on("$locationChangeStart", function (event, next, current) {
      const path = $location.path();
      $rootScope.currentPage = path.replace("/", "");
      if (path && path !== "/") {
        let loggedIn = $authUser.loggedIn();
        if (!loggedIn) {
          $timeout(function () {
            $state.go("login");
          });
        } else {
          const privatePages = [
            "/home",
            "/partner",
            "/product",
            "/configure",
            "/policy",
            "/policydetails",
            "/policysearch",
            "/claim",
            "/claimdetails",
            "/claimsearch",
            "/dashboard",
            "/importdata",
            "/user",
            "/privilege",
            "/profile",
            "/changepassword",
            "/report",
            "/nirvoyenroll",
            "/nirvoyclaim"
          ];
          const notFound = privatePages.indexOf(path) === -1;
          if (notFound) {
            $location.path("/notfound");
          }
        }
      }
    });
    $rootScope.$on("$viewContentLoading", function (event, viewConfig) {
      $utility.ShowWait();
    });
    $rootScope.$on("$viewContentLoaded", function (
      event,
      viewName,
      viewContent
    ) {
      $utility.HideWait();
    });
    // $rootScope.$on("$locationChangeSuccess", function() {
    //   $utility.HideWait();
    // });
  }
]);
