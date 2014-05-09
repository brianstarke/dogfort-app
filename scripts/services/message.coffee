app = angular.module 'dogfort'

app.factory 'Message', ['$http', ($http) ->
  new class Message
    constructor: ->
      @svcUrl = '/api/v1/messages'

    send: (text, channelId) ->
      $http.post @svcUrl, {
        text      : text
        channelId : channelId
      }

    byChannel: (channelId, beforeTs, numResults) ->
      $http.get "#{@svcUrl}/channel/#{channelId}/before/#{beforeTs}/num/#{numResults}"
]
