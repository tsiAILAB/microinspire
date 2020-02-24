MicroInspireApp.config(function ($urlRouterProvider, $locationProvider, $httpProvider) {
    $urlRouterProvider.otherwise("/");
    $locationProvider.hashPrefix("");
    $httpProvider.interceptors.push(function ($q, $location, $authUser) {
        return {
            // Add authorization token to headers
            request: function (config) {
                config.headers = config.headers || {};
                const token = $authUser.getToken();
                if (token) config.headers.Authorization = "Bearer " + token;
                return config;
            },

            // Intercept 401s and redirect you to login
            responseError: function (response) {
                if (response.status === 401) {
                    // remove token and redirect to login.
                    $authUser.logOut();
                    $location.path("/");
                    return $q.reject(response);
                } else
                    return $q.reject(response);
            }
        };
    });
});
MicroInspireApp.filter('nl2p', function () {
    return function (text) {
        text = String(text).trim();
        return (text.length > 0 ? '<p>' + text.replace(/[\r\n]+/g, '</p><p>') + '</p>' : null);
    }
});