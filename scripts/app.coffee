app = angular.module 'dogfort', [
  'ngRoute'
  'ngCookies'
  'ngSanitize'

  'toastr'
  'angularMoment'
  'luegg.directives'
]

app.config [
  '$routeProvider'
  '$httpProvider'
  '$sceProvider'
  'toastrConfig'

  ($routeProvider, $httpProvider, $sceProvider, toastrConfig) ->
    $httpProvider.interceptors.push 'authInterceptor'

    $sceProvider.enabled false

    $routeProvider.when '/login', {
      templateUrl: '/partials/login.html'
      controller: 'LoginCtrl'
    }

    $routeProvider.when '/channels', {
      templateUrl: '/partials/channels.html'
      controller: 'ChannelsCtrl'
    }

    $routeProvider.when '/chat', {
      templateUrl: '/partials/chat.html'
      controller: 'ChatCtrl'
    }

    $routeProvider.otherwise {
      redirectTo: '/login'
    }

    toastrConfig.positionClass = 'toast-bottom-full-width'
]
