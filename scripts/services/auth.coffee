app = angular.module 'dogfort'

app.factory 'Auth', ['$http', ($http) ->
  new class Auth
    authenticate: (creds) ->
      $http.post '/api/v1/auth', creds

    userByAuth: ->
      $http.get '/api/v1/auth'
]
