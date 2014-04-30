app = angular.module 'dogfort'

app.factory 'Channel', ['$http', ($http) ->
  new class Channel
    constructor: ->
      @svcUrl = '/api/v1/channels'

    list: ->
      $http.get @svcUrl

    byUser: (id) ->
      $http.get "#{@svcUrl}/user/#{id}"

    create: (channel) ->
      $http.post @svcUrl, channel

    join: (id) ->
      $http.get "#{@svcUrl}/join/#{id}"

    leave: (id) ->
      $http.get "#{@svcUrl}/leave/#{id}"
]
