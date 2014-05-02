app = angular.module 'dogfort'

app.factory 'User', ['$http', ($http) ->
  new class User
    constructor: ->
      @baseUrl = '/api/v1'

    create: (newUser) ->
      $http.post @baseUrl + '/users', newUser

    byId: (userId) ->
      $http.get @baseUrl + '/users/' + userId, { cache: true }
]

app.factory 'authInterceptor',  ['$q', '$cookies', '$location', ($q, $cookies, $location) ->
  request: (config) ->
    config.headers = config.headers or {}

    if $cookies.dogfort_token
      config.headers.Authorization = $cookies.dogfort_token
    config
  response: (response) ->
    if response.status is 401
      $location.path '/login'

    response or $q.when(response)
]
